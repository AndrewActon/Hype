//
//  SignUpViewController.swift
//  Hype
//
//  Created by Andrew Acton on 3/25/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var profilePhoto: UIImage?

    //MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty,
              let bio = bioTextField.text
        else { return }
        
        UserController.shared.createUser(with: username, bio: bio, profilePhoto: profilePhoto) { success in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 2
        photoContainerView.clipsToBounds = true
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { success in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPickerVC" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
    }

}

extension SignUpViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.profilePhoto = image
    }
}//End Of Extension
