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
    
    // MARK: - Properties
    private var imageSelected = false
    
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
            passwordTextField.hasText else {
                signUpButton.isEnabled = false
                signUpButton.alpha = 0.5
                return
        }
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
    }
    
    @IBAction func addPicturePressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        UserNetworkManager.shared.createUser(email: email,
                                             password: password,
                                             profileImage: profileImageView.image,
                                             name: name,
                                             username: username)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        profileImageView.image = profileImage
        profileImageView.roundImage()
        imageSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
