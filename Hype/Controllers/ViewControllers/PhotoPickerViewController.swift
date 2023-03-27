//
//  PhotoPickerViewController.swift
//  Hype
//
//  Created by Andrew Acton on 3/26/23.
//

import UIKit

protocol PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var delegate: PhotoPickerDelegate?

    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
 
    }
    
    //MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.imagePicker.dismiss(animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openGallery()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .lightGray
        imagePicker.delegate = self
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            let alert = UIAlertController(title: "No camera access.", message: "Please allow access to the camera in setting to use this feature", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            let alert = UIAlertController(title: "No Photos Access", message: "Please allow access to photos to access this feature", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerSelected(image: pickedImage)
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }
    
}//End Of Class


extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}// End Of extension
