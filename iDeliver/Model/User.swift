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
    var uid: String?
    
    init(uid: String, dictionary: Dictionary<String?, String>) {
        self.uid = uid
        if let profileImageURL = dictionary["profileImageURL"] {
            self.profileImageURL = profileImageURL
        }
        if let email = dictionary["email"] {
            self.email = email
        }
        if let name = dictionary["name"] {
            self.name = name
        }
        if let username = dictionary["username"] {
            self.username = username
        }
        if let birthday = dictionary["birthday"] {
            self.birthday = birthday
        }
        if let mobileCell = dictionary["mobileCell"] {
            self.mobileCell = mobileCell
        }
        if let additionalEmail = dictionary["additionalEmail"] {
            self.additionalEmail = additionalEmail
        }
        
    }
}
