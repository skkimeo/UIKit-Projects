//
//  PhotoViewController+UIImagePicker.swift
//  PictureFeaturePractice
//
//  Created by sun on 2022/09/17.
//

import UIKit

extension PhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage
        else { return }
        
        let imageName = UUID().uuidString
        let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
        print(imagePath)
        
        // saving
//        if let jpegData = image.jpegData(compressionQuality: 0.8) {
//            try? jpegData.write(to: imagePath)
//        }
        
        self.imageView.image = image
//
        self.dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension PhotoViewController: UINavigationControllerDelegate {}
