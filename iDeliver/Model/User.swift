//
//  User.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/21/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct User {
    var name: String!
    var username: String!
//    var profileImageURL: String!
    var uid: String!
    
    init(uid: String, dictionary: Dictionary<String?, String>) {
        self.uid = uid
        if let name = dictionary["name"] {
            self.name = name
        }
        if let username = dictionary["username"] {
            self.username = username
        }
//        if let profileImageURL = dictionary["profileImageURL"] as? String {
//            self.profileImageURL = profileImageURL
//        }
    }
}
