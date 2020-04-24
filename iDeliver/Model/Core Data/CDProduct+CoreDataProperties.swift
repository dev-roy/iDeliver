//
//  CDProduct+CoreDataProperties.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/24/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//
//

import Foundation
import CoreData


extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var dateAdded: Date
    @NSManaged public var sku: Int64

}
