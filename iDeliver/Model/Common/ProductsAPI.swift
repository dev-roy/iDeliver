//
//  File.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

class ProductsAPI {
    private static let categoriesJsonFilename = "CategoriesSlice"
    
    static func getMockAllCategories() -> [Category]? {
        let res: [Category]? = JSONUtil.loadJSON(fileName: categoriesJsonFilename)
        return res
    }
    
    static func getMockTopCategories() -> [Category] {
        guard let res = getMockAllCategories()?.shuffled() else {
            return []
        }
        return Array(res[0...5])
    }
}
