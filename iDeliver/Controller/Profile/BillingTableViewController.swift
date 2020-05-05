//
//  BillingTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/5/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FDTextFieldTableViewCell

class BillingTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var sameAsShippingCell: UITableViewCell!
    @IBOutlet weak var streetCell: FDTextFieldTableViewCell!
    @IBOutlet weak var street2Cell: FDTextFieldTableViewCell!
    @IBOutlet weak var cityCell: FDTextFieldTableViewCell!
    @IBOutlet weak var stateCell: FDTextFieldTableViewCell!
    @IBOutlet weak var zipCodeCell: FDTextFieldTableViewCell!
    @IBOutlet weak var countryCell: FDTextFieldTableViewCell!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var sameAsShipping: UISwitch!
    
    // MARK: - Properties
    var user: User?
    private var editMode = false
    private var editingChanged = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        addTargets()
    }
    
    func fetchAddress() {
        guard let user = user else { return }
        UserNetworkManager.shared.fetchCurrentUserAddress(user: user) { (address) in
            self.streetCell.textField.text = address.street1
            self.street2Cell.textField.text = address.street2
            self.cityCell.textField.text = address.city
            self.stateCell.textField.text = address.state
            self.zipCodeCell.textField.text = address.zipCode
            self.countryCell.textField.text = address.countryOrRegion
        }
    }
    
    func addTargets() {
        streetCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        street2Cell.textField.addTarget(self, action:  #selector(editValidation), for: .editingChanged)
        cityCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        stateCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        zipCodeCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
        countryCell.textField.addTarget(self, action: #selector(editValidation), for: .editingChanged)
    }
    
    func clearTextFields() {
        streetCell.textField.text = ""
        street2Cell.textField.text = ""
        cityCell.textField.text = ""
        stateCell.textField.text = ""
        zipCodeCell.textField.text = ""
        countryCell.textField.text = ""
    }
    
    func enableCells() {
        sameAsShippingCell.isUserInteractionEnabled = true
        streetCell.isUserInteractionEnabled = true
        street2Cell.isUserInteractionEnabled = true
        cityCell.isUserInteractionEnabled = true
        stateCell.isUserInteractionEnabled = true
        zipCodeCell.isUserInteractionEnabled = true
        countryCell.isUserInteractionEnabled = true
    }
    
    func disableCells() {
        streetCell.isUserInteractionEnabled = false
        street2Cell.isUserInteractionEnabled = false
        cityCell.isUserInteractionEnabled = false
        stateCell.isUserInteractionEnabled = false
        zipCodeCell.isUserInteractionEnabled = false
        countryCell.isUserInteractionEnabled = false
    }
    
    
    @IBAction func sameAsShippingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            fetchAddress()
            disableCells()
            editingChanged = true
            editButton.isEnabled = true
            editButton.tintColor = .systemBlue
        } else {
            clearTextFields()
            enableCells()
            editingChanged = false
            editButton.isEnabled = false
            editButton.tintColor = .lightGray
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        editMode = !editMode
        if editMode {
            enableCells()
            sender.tintColor = .lightGray
            sender.title = "Done"
            sender.isEnabled = false
        } else {
            sender.title = "Edit"
            sameAsShippingCell.isUserInteractionEnabled = false
            disableCells()
            if editingChanged {
                updateValues()
            }
        }
    }
    
    @objc func editValidation() {
        if sameAsShipping.isOn {
            sameAsShipping.setOn(false, animated: true)
        }
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
                let street2 = street2Cell.textField.text,
                let city = cityCell.textField.text,
                let state = stateCell.textField.text,
                let zipCode = zipCodeCell.textField.text,
                let country = countryCell.textField.text else { return }
            let address = Address(street1: street1,
                                  street2: street2,
                                  city: city,
                                  state: state,
                                  zipCode: zipCode,
                                  countryOrRegion: country)
            user?.billingAddress = address
        }
    }
    
}
