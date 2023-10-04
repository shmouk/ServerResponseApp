import Foundation
import UIKit

enum MyError: Error {
    case invalidResponse
    case invalidData
    case invalidImage
    case invalidURL
    case invalidRange
}

class RequestAPI {
    static let shared = RequestAPI()
    private let imagePickerManager = ImagePickerManager()

    var page = 0
    var pageSize = 0
    var usersInfo = [UserModel]()
    
    private init() { }
    
    func fetchInfo(completion: @escaping (Result<InfoModel, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            let group = DispatchGroup()
            
            fetchRequestDict { result in
                switch result {
                case .success(let dict):
                    guard let contentArray = dict["content"] as? [[String: Any]],
                          let pageSize = dict["pageSize"] as? Int,
                          let page = dict["page"] as? Int,
                          let totalPages = dict["totalPages"] as? Int,
                          let totalElements = dict["totalElements"] as? Int else {
                        DispatchQueue.main.async {
                            completion(.failure(MyError.invalidResponse))
                        }
                        return
                    }
                    
                    guard self.isPageFully(pageSize, totalElements, totalPages) else {
                        DispatchQueue.main.async {
                            completion(.failure(MyError.invalidRange))
                        }
                        return
                    }
                    group.enter()
                    self.pickUsersInfo(contentArray) { usersInfo in
                        self.usersInfo.append(contentsOf: usersInfo)
                        group.leave()
                    }
                    
                    group.notify(queue: .main) {
                        let info = InfoModel(totalPages: totalPages, pageSize: self.pageSize, page: page, totalElements: totalElements, userInfo: self.usersInfo)
                        DispatchQueue.main.async {
                            completion(.success(info))
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func isPageFully(_ pageSize: Int, _ totalElements: Int, _ totalPages: Int) -> Bool {
        guard self.pageSize < totalElements, self.page < totalPages else { return false }
        
        if (self.pageSize + pageSize) >= totalElements,
           self.page + 1 >= totalPages {
            self.pageSize += totalElements - self.pageSize
        } else {
            self.pageSize += pageSize
            self.page += 1
        }
        
        return true
    }

    private func pickUsersInfo(_ contentArray: [[String: Any]], completion: @escaping ([UserModel]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var usersInfo = [UserModel]()
            for contentItem in contentArray {
                guard let name = contentItem["name"] as? String,
                      let id = contentItem["id"] as? Int64 else {
                    return
                }
                let url = contentItem["image"] as? URL
                self.downloadImage(from: url) { image, _ in
                    let info = UserModel(name: name, photo: image, typeId: id)
                    usersInfo.append(info)
                }
            }
            
            DispatchQueue.main.async {
                completion(usersInfo)
            }
        }
    }
    
    private func fetchRequestDict(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        sendGetRequest { data, error in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    guard let data = data,
                          let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(MyError.invalidData))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(dict))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func prepareData(_ viewController: UIViewController, _ names: [String], _ id: Int64, completion: @escaping DataCompletion)  {
        imagePickerManager.pickCamera(viewController) { photo in
            if let imageData = photo.jpegData(compressionQuality: 0.2) {
                
                let newParameters: [String: Any] = [
                    "name": names,
                    "photo": imageData.base64EncodedString(),
                    "typeId": id
                ]
                
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    sendPostRequest(with: newParameters) { data, error in
                        DispatchQueue.main.async {
                            completion(data, error)
                        }
                    }
                }
            }
        }
    }
    
    func sendPostRequest(with parameters: [String: Any], completion: @escaping DataCompletion) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type") else {
            completion(nil, MyError.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                completion(data, error)
            }
            
            task.resume()
        } catch {
            completion(nil, error)
        }
    }
    
    func sendGetRequest(completion: @escaping DataCompletion) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type?page=" + String(page)) else {
            completion(nil, MyError.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }
        task.resume()
    }
    
    private func downloadImage(from url: URL?, completion: @escaping (UIImage, Error?) -> Void) {
        guard let url = url else {
            completion(UIImage(), MyError.invalidURL)
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(UIImage(), MyError.invalidImage)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }.resume()
        }
    }
}
