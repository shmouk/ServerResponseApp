import Foundation
import UIKit

class UserModel {
    var name: String
    var photo: UIImage
    var typeId: Int64
    
    init(name: String = "", photo: UIImage = UIImage(), typeId: Int64 = 0) {
        self.name = name
        self.photo = photo
        self.typeId = typeId
    }
}
