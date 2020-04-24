//
//  CDProduct+CoreDataProperties.swift
//  
//
//  Created by Hugo Flores Perez on 4/23/20.
//
//

import Foundation
import CoreData


extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var sku: Int64

}
