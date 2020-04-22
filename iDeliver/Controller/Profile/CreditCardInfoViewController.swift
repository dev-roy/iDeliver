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

class CreditCardInfoViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let paymentTextField = STPPaymentCardTextField()
    let cardHolderTextField = UITextField()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPaymentTextField()
        setUpCardHolderTextField()
    }
    
    func setUpPaymentTextField() {
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
        view.addSubview(paymentTextField)

        NSLayoutConstraint.activate([
        paymentTextField.topAnchor.constraint(equalTo: creditCardForm.bottomAnchor, constant: 20),
        paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
        paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        paymentTextField.delegate = self
    }
    
    func setUpCardHolderTextField() {
        cardHolderTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cardHolderTextField.placeholder = "CARDHOLDER NAME"
        cardHolderTextField.autocapitalizationType = .allCharacters
        cardHolderTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        cardHolderTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardHolderTextField)
        
        NSLayoutConstraint.activate([
        cardHolderTextField.topAnchor.constraint(equalTo: paymentTextField.bottomAnchor, constant: 0),
        cardHolderTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        cardHolderTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        cardHolderTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
        cardHolderTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        cardHolderTextField.delegate = self
    }
    
    // MARK: - Handlers
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveButton.title = "Saved"
        saveButton.isEnabled = false
    }
}

// MARK: - Extensions
extension CreditCardInfoViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
    creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditing(_ textField: STPPaymentCardTextField) {
        saveButton.isEnabled = true
    }
}

extension CreditCardInfoViewController: UITextFieldDelegate {
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
}


