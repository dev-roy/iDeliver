//
//  LoginViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/19/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    // MARK: - Handlers
    func addTargets() {
        usernameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    @objc func formValidation() {
           guard
               usernameTextField.hasText,
               passwordTextField.hasText else {
                   loginButton.isEnabled = false
                   loginButton.alpha = 0.5
                   return
           }
           
           loginButton.isEnabled = true
           loginButton.alpha = 1.0
       }

    @IBAction func loginPressed(_ sender: Any) {
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Unable to sign user in with error", error.localizedDescription)
                let alert = UIAlertController(title: "Incorrect email / password. Please try again.", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Succesfully signed in
            print("Succesfully signed user in")
            self.performSegue(withIdentifier: "loginGranted", sender: sender)
        }
    }

}

extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
