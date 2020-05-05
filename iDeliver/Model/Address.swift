//
//  Address.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct Address: Codable {
    var street1: String
    var street2: String
    var city: String
    var state: String
    var zipCode: String
    var countryOrRegion: String
}
