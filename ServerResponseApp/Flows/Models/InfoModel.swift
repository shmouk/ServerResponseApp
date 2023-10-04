import Foundation

class InfoModel {
    var totalPages: Int
    var pageSize: Int
    var page: Int
    var totalElements: Int
    var userInfo: [UserModel]
    
    init(totalPages: Int = 0, pageSize: Int = 0, page: Int = 0, totalElements: Int = 0, userInfo: [UserModel] = [UserModel]()) {
        self.totalPages = totalPages
        self.pageSize = pageSize
        self.page = page
        self.totalElements = totalElements
        self.userInfo = userInfo
    }
}

