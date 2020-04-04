//
//  Product.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct Product: Codable {
    let sku: Int
    let name, type: String
    let price: Double
    let upc: String
    let category: [Category]
    let shipping: Double
    let description, manufacturer: String
    let model: String?
    let url: String
    let image: String
}
