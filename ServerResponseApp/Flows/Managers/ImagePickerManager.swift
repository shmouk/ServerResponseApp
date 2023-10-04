import Foundation
import Photos
import UIKit

class ImagePickerManager: NSObject {
    var viewController: UIViewController?
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func pickCamera(_ viewController: UIViewController, _ completion: @escaping (UIImage) -> Void) {
        self.viewController = viewController
        self.imagePickedBlock = completion
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickedBlock?(image)
        }
    }
}
extension ImagePickerManager: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
