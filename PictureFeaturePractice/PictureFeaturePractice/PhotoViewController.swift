//
//  PhotoViewController.swift
//  PictureFeaturePractice
//
//  Created by sun on 2022/09/17.
//

import PhotosUI
import UIKit

import Then

final class PhotoViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var photosButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func photosButtonDidTap(_ sender: UIButton) {
//        self.presentImagePicker()
        self.presentPicker()
    }
    
    
    // MARK: - PHPPickerView
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    
    // MARK: - UIImagePickerView
    
    private func presentImagePicker() {
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        let picker = UIImagePickerController().then {
            $0.allowsEditing = true
            $0.delegate = self
        }
        
        self.present(picker, animated: true)
    }
}


extension PhotoViewController:  PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        
        guard let selectedItem = results.first
        else { return print("No selection")}
        
        self.displayImage(selectedItem)
    }
}

extension PhotoViewController {
    func displayImage(_ selectedItem: PHPickerResult) {
        let progress: Progress?
        let itemProvider = selectedItem.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(
                        assetIdentifier: selectedItem.assetIdentifier ?? "",
                        object: image,
                        error: error
                    )
                }
            }
        } else {
            progress = nil
        }
        
        self.displayProgress(progress)
    }
    
    func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
        if let image = object as? UIImage {
            self.displayImage(image)
        } else if let error = error {
            print("Couldn't display \(assetIdentifier) with error: \(error)")
            self.displayErrorImage()
        } else {
            self.displayUnknownImage()
        }
    }
    
    func displayEmptyImage() {
        displayImage(UIImage(systemName: "photo.on.rectangle.angled"))
    }
    
    func displayErrorImage() {
        displayImage(UIImage(systemName: "exclamationmark.circle"))
    }
    
    func displayUnknownImage() {
        displayImage(UIImage(systemName: "questionmark.circle"))
    }
    
    func displayProgress(_ progress: Progress?) {
        imageView.image = nil
        imageView.isHidden = true
//        progressView.observedProgress = progress
//        progressView.isHidden = progress == nil
//        print(progress == nil)
    }
    
    func displayImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
//        progressView.observedProgress = nil
//        progressView.isHidden = true
    }
       
}
