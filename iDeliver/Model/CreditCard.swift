//
//  CreditCard.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct CreditCard: Codable {
    var cardNumber: String
    var expirationMonth: UInt
    var expirationYear: UInt
    var cvc: String
    var zipCode: String
    var cardHolderName: String
}
