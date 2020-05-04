//
//  NameTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FDTextFieldTableViewCell
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class NameTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameCell: FDTextFieldTableViewCell!
    @IBOutlet weak var usernameCell: FDTextFieldTableViewCell!
    @IBOutlet weak var emailCell: FDTextFieldTableViewCell!
    @IBOutlet weak var birthdayCell: FDTextFieldTableViewCell!
    @IBOutlet weak var mobileCell: FDTextFieldTableViewCell!
    @IBOutlet weak var additionalEmailCell: FDTextFieldTableViewCell!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: Properties
    var user: User?
    private var willEditText = false
    private var editingChanged = false
    private var profileImageChanged = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        updateUI()
        addTargets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if editingChanged {
            guard let user = user else { return }
            UserNetworkManager.shared.updateUser(user: user)
        }
    }
    
    // MARK: - Init
    func addTargets() {
        nameCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        birthdayCell.textField.addInputViewDatePicker(target: self, selector:  #selector(doneButtonPressed))
        mobileCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        additionalEmailCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
    }
    
    func updateUI() {
        profileImageView.roundImage()
        mobileCell.textField.keyboardType = .numberPad
        additionalEmailCell.textField.keyboardType = .emailAddress
        additionalEmailCell.textField.autocapitalizationType = .none
        nameCell.textField.text = user?.name
        usernameCell.textField.text = user?.username
        emailCell.textField.text = user?.email
        birthdayCell.textField.text = user?.birthday
        mobileCell.textField.text = user?.mobileCell
        additionalEmailCell.textField.text = user?.additionalEmail
        if let imageURL = user?.profileImageURL {
            let url = URL(string: imageURL)
            self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
   // MARK: - Handlers
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        willEditText = !willEditText
        if willEditText {
            nameCell.isUserInteractionEnabled = true
            birthdayCell.isUserInteractionEnabled = true
            mobileCell.isUserInteractionEnabled = true
            additionalEmailCell.isUserInteractionEnabled = true
            sender.tintColor = .lightGray
            sender.title = "Done"
            sender.isEnabled = false
        } else {
            sender.title = "Edit"
            nameCell.isUserInteractionEnabled = false
            birthdayCell.isUserInteractionEnabled = false
            mobileCell.isUserInteractionEnabled = false
            additionalEmailCell.isUserInteractionEnabled = false
            if editingChanged {
                updateValues()
            }
        }
    }
    
    @objc func editValidation() {
        if mobileCell.textField.isFirstResponder {
            guard let text = mobileCell.textField.text else { return }
            mobileCell.textField.text = text.applyPatternOnNumbers(pattern: "(###)-###-####", replacmentCharacter: "#")
        }
        guard nameCell.textField.hasText else {
            editButton.isEnabled = false
            return
        }
        editButton.tintColor = .systemBlue
        editButton.isEnabled = true
        editingChanged = true
    }
    
    @IBAction func changePhotoPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.birthdayCell.textField.inputView as? UIDatePicker {
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
            self.birthdayCell.textField.text = dateFormatter.string(from: datePicker.date)
       }
        editButton.tintColor = .systemBlue
        editButton.isEnabled = true
        editingChanged = true
        self.birthdayCell.textField.resignFirstResponder()
    }
    
    func updateValues() {
        if editingChanged {
            user?.name = nameCell.textField.text
            if birthdayCell.textField.hasText {
                user?.birthday = birthdayCell.textField.text
            }
            if mobileCell.textField.hasText {
                user?.mobileCell = mobileCell.textField.text
            }
            if additionalEmailCell.textField.hasText {
                user?.additionalEmail = additionalEmailCell.textField.text
            }
        }
    }
}

extension NameTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            profileImageChanged = false
            return
        }
        profileImageView.image = profileImage
        profileImageChanged = true
        dismiss(animated: true) {
            guard let user = self.user else { return }
            UserNetworkManager.shared.updateProfileImage(user: user,
                                                         profileImage: profileImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
