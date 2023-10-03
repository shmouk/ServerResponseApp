//
//  CameraAPI.swift
//  ServerResponseApp
//
//  Created by Марк on 3.10.23.
//

import Foundation
import Photos
import UIKit

class CameraViewModel {
    var currentUser = Bindable(User())
    let userAPI = UserAPI.shared
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .denied, .restricted, .notDetermined, .limited:
                DispatchQueue.main.async {
                    completion(false)
                }
            @unknown default:
                completion(false)
            }
        }
    }
    
}
extension CameraViewModel: UIImagePickerControllerDelegate {
    
    func selectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            profileViewModel.loadImagePicker(image: selectedImage)
        }
        dismiss(animated: true)
    }
}

extension CameraViewModel: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

