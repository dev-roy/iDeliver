//
//  ShippingTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FDTextFieldTableViewCell

class ShippingTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var streetCell: FDTextFieldTableViewCell!
    @IBOutlet weak var street2cell: FDTextFieldTableViewCell!
    @IBOutlet weak var cityCell: FDTextFieldTableViewCell!
    @IBOutlet weak var stateCell: FDTextFieldTableViewCell!
    @IBOutlet weak var zipCodeCell: FDTextFieldTableViewCell!
    @IBOutlet weak var countryCell: FDTextFieldTableViewCell!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Properties
    var user: User?
    private var willEditText = false
    private var editingChanged = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        fetchAddress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if editingChanged {
            guard let user = user else { return }
            UserNetworkManager.shared.updateUserAddress(user: user)
        }
    }
    
    func fetchAddress() {
        UserNetworkManager.shared.fetchCurrentUserAddress()
    }
    
    func addTargets() {
        streetCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        street2cell.textField.addTarget(self, action:  #selector(editValidation), for: .editingChanged)
        cityCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        stateCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        zipCodeCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        countryCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        willEditText = !willEditText
        if willEditText {
            streetCell.isUserInteractionEnabled = true
            street2cell.isUserInteractionEnabled = true
            cityCell.isUserInteractionEnabled = true
            stateCell.isUserInteractionEnabled = true
            zipCodeCell.isUserInteractionEnabled = true
            countryCell.isUserInteractionEnabled = true
            sender.tintColor = .lightGray
            sender.title = "Done"
            sender.isEnabled = false
        } else {
            sender.title = "Edit"
            streetCell.isUserInteractionEnabled = false
            street2cell.isUserInteractionEnabled = false
            cityCell.isUserInteractionEnabled = false
            stateCell.isUserInteractionEnabled = false
            zipCodeCell.isUserInteractionEnabled = false
            countryCell.isUserInteractionEnabled = false
            if editingChanged {
                updateValues()
            }
        }
    }
    
    @objc func editValidation() {
        guard streetCell.textField.hasText,
            cityCell.textField.hasText,
            stateCell.textField.hasText,
            zipCodeCell.textField.hasText,
            countryCell.textField.hasText else {
                editButton.isEnabled = false
                return
        }
        editButton.tintColor = .systemBlue
        editButton.isEnabled = true
        editingChanged = true
    }
    
    func updateValues() {
        if editingChanged {
            guard let street1 = streetCell.textField.text,
                let street2 = street2cell.textField.text,
                let city = cityCell.textField.text,
                let state = stateCell.textField.text,
                let zipCode = zipCodeCell.textField.text,
                let country = countryCell.textField.text else { return }
            let address = Address(street1: street1, street2: street2, city: city, state: state, zipCode: zipCode, countryOrRegion: country)
            user?.address = address
        }
    }

}
