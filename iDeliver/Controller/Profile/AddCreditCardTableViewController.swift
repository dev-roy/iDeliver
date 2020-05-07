//
//  CreditCardInfoViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/22/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe

class AddCreditCardTableViewController: UITableViewController {
    // MARK: - Properties
    @IBOutlet weak var creditCardCell: UITableViewCell!
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let paymentTextField = STPPaymentCardTextField()
    let cardHolderTextField = UITextField()
    
    // MARK: - Properties
    var user: User?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPaymentTextField()
        setUpCardHolderTextField()
    }
    
    // MARK: - Init
    private func setUpPaymentTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        creditCardCell.contentView.addSubview(paymentTextField)

        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardForm.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: creditCardCell.contentView.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.creditCardCell.contentView.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        paymentTextField.delegate = self
    }
    
    private func setUpCardHolderTextField() {
        cardHolderTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cardHolderTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: UIControl.Event.primaryActionTriggered)
        cardHolderTextField.placeholder = "CARDHOLDER NAME"
        cardHolderTextField.autocapitalizationType = .allCharacters
        cardHolderTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        cardHolderTextField.translatesAutoresizingMaskIntoConstraints = false
        creditCardCell.contentView.addSubview(cardHolderTextField)
        
        NSLayoutConstraint.activate([
            cardHolderTextField.topAnchor.constraint(equalTo: paymentTextField.bottomAnchor, constant: 0),
            cardHolderTextField.leftAnchor.constraint(equalTo: creditCardCell.contentView.leftAnchor, constant: 20),
            cardHolderTextField.centerXAnchor.constraint(equalTo: creditCardCell.contentView.centerXAnchor),
            cardHolderTextField.widthAnchor.constraint(equalToConstant: self.creditCardCell.contentView.frame.size.width-20),
            cardHolderTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        cardHolderTextField.delegate = self
    }
    
    // MARK: - Handlers
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveButton.title = "Saved"
        saveButton.isEnabled = false
        guard let user = user else { return }
        UserNetworkManager.shared.updateCreditCardInfo(user: user)
    }
}

// MARK: - Extensions
extension AddCreditCardTableViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber,
                                                     expirationYear: textField.expirationYear,
                                                     expirationMonth: textField.expirationMonth,
                                                     cvc: textField.cvc)
        saveButton.isEnabled = false
    }
    
    func paymentCardTextFieldDidEndEditing(_ textField: STPPaymentCardTextField) {
        if cardHolderTextField.hasText {
            saveButton.isEnabled = true
        }
    }
}

extension AddCreditCardTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        creditCardForm.cardHolderPlaceholderString = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardForm.cardHolderPlaceholderString = ""
        var tempName = ""
        if let typedText = textField.text {
            tempName = typedText
        }
        creditCardForm.cardHolderPlaceholderString.write(tempName)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if paymentTextField.hasText {
            saveButton.isEnabled = true
            guard let cardNumber = paymentTextField.cardNumber,
                let cvc = paymentTextField.cvc,
                let zipCode = paymentTextField.postalCode,
                let cardHolder = cardHolderTextField.text else { return }
            let creditCard = CreditCard(cardNumber: cardNumber,
                                        expirationMonth: paymentTextField.expirationMonth,
                                        expirationYear: paymentTextField.expirationYear,
                                        cvc: cvc, zipCode: zipCode,
                                        cardHolderName: cardHolder)
            user?.creditCard = creditCard
            view.endEditing(true)
        }
    }
}


