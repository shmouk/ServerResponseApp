import Foundation
import UIKit

class ViewModel {
    private let requestAPI = RequestAPI.shared
    var data = Bindable(InfoModel())
    var isLoadingMore = false

    func receiveInfo() {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        requestAPI.fetchInfo { [self] result in
            switch result {
            case .success(let info):
                self.data.value = info
            case .failure(let error):
                print(error.localizedDescription)
            }
            isLoadingMore = false
        }
    }
    
    func captureData(_ viewController: UIViewController, id: Int64) {
        let fullName = Bundle.main.infoDictionary?["CFBundleDeveloperName"] as? String
        let names = fullName?.components(separatedBy: " ") ?? ["noName"]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            requestAPI.prepareData(viewController, names, id) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    showAlert(viewController, withTitle: "Alert", message: error.localizedDescription)
                } else {
                    showAlert(viewController, withTitle: "Alert", message: "Complete loading data: \(String(describing: data))")
                }
            }
        }
    }
    
    func showAlert(_ viewController: UIViewController, withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}




    
