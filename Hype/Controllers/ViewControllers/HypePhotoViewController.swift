//
//  HypePhotoViewController.swift
//  Hype
//
//  Created by Andrew Acton on 3/26/23.
//

import UIKit

class HypePhotoViewController: UIViewController {
    
    var image: UIImage?

    //MARK: - Outlets
    @IBOutlet weak var hypeTextField: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let text = hypeTextField.text, !text.isEmpty,
              let image = image
        else { return }
        
        HypeController.shared.saveHype(with: text, photo: image) { success in
            if success {
                self.dismissView()
            }
        }
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 10
        photoContainerView.clipsToBounds = true
    }
    
    func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPickerVC" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
    }

}

extension HypePhotoViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}//End Of Extensions
