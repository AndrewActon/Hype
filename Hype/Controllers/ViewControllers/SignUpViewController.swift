//
//  SignUpViewController.swift
//  Hype
//
//  Created by Andrew Acton on 3/25/23.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty,
              let bio = bioTextField.text
        else { return }
        
        UserController.shared.createUser(with: username, bio: bio) { success in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    //MARK: - Helper Methods
    
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

}
