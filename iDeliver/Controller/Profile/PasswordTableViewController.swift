//
//  PasswordTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/5/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FirebaseAuth
import ValidationTextField

class PasswordTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var newPasswordTextField: ValidationTextField!
    @IBOutlet weak var confirmPasswordTextField: ValidationTextField!
    @IBOutlet weak var confirmButton: UIButton!
    var user: User?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        newPasswordTextField.validCondition = {$0.count > 8}
        confirmPasswordTextField.validCondition = {
            guard let password = self.newPasswordTextField.text else {
                return false
            }
            if $0 == password {
                self.confirmButton.isEnabled = true
            } else {
                self.confirmButton.isEnabled = false
            }
            return $0 == password
        }
        
    }
    
    // MARK: - Handlers
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default) { (action) in
            guard let resetEmail = forgotPasswordAlert.textFields?.first?.text else { return }
            Auth.auth().sendPasswordReset(withEmail: resetEmail) { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            }
        })
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let confirmedPassword = confirmPasswordTextField.text else { return }
        Auth.auth().currentUser?.updatePassword(to: confirmedPassword) { (error) in
            if error == nil {
                let updateSuccesfulAlert = UIAlertController(title: "Password updated successfully", message: "", preferredStyle: .alert)
                updateSuccesfulAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(updateSuccesfulAlert, animated: true, completion: nil)
            } else {
                let updateFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                updateFailedAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(updateFailedAlert, animated: true, completion: nil)
            }
        }
    }
}

