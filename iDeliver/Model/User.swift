//
//  User.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/21/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct User {
    var profileImageURL: String?
    var email: String?
    var name: String?
    var username: String?
    var birthday: String?
    var mobileCell: String?
    var additionalEmail: String?
    var shippingAddress: Address?
    var billingAddress: Address?
    var uid: String?
    
    init(uid: String, dictionary: Dictionary<String?, Any>) {
        self.uid = uid
        if let profileImageURL = dictionary["profileImageURL"] {
            self.profileImageURL = profileImageURL as? String
        }
        if let email = dictionary["email"] {
            self.email = email as? String
        }
        if let name = dictionary["name"] {
            self.name = name as? String
        }
        if let username = dictionary["username"] {
            self.username = username as? String
        }
        if let birthday = dictionary["birthday"] {
            self.birthday = birthday as? String
        }
        if let mobileCell = dictionary["mobileCell"] {
            self.mobileCell = mobileCell as? String
        }
        if let additionalEmail = dictionary["additionalEmail"] {
            self.additionalEmail = additionalEmail as? String
        }
    }
}
