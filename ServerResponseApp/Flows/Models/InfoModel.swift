import Foundation
import UIKit

class InfoModel {
    @objc dynamic var name: String
    @objc dynamic var photo: UIImage
    @objc dynamic var typeId: String
    @objc dynamic var pageSize: Int
    @objc dynamic var totalElemets: Int
    
    init(name: String = "", photo: UIImage = UIImage(), typeId: String = "") {
        self.name = name
        self.photo = photo
        self.typeId = typeId
    }
}
