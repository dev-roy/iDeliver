//
//  SignUpViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/19/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var imageSelected = true
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        nameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    // MARK: - Handlers
    @objc func formValidation() {
        guard
            nameTextField.hasText,
            emailTextField.hasText,
            usernameTextField.hasText,
            passwordTextField.hasText,
            imageSelected == true else {
                signUpButton.isEnabled = false
                signUpButton.alpha = 0.5
                return
        }
        
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // handle error
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            let dictionaryValues = ["name": name,
                                    "username": username]
            let values = [user?.user.uid: dictionaryValues]
            
            // Save user info to database
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                print("Succesfuly created user and saved information to database")
                self.dismiss(animated: true, completion: nil)
            })
                   
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        print("pressed")
        dismiss(animated: true, completion: nil)
    }
    
    

}
