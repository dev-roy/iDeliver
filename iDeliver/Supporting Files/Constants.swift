//
//  Constants.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let DB_REF = Database.database().reference()
let USER_REF = DB_REF.child("users")
let STORAGE_REF = Storage.storage().reference()
