//
//  UserNetworkManager.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class UserNetworkManager {
    
    static let shared = UserNetworkManager()
    
    func createUser(email: String,
                    password: String,
                    profileImage: UIImage?,
                    name: String,
                    username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            guard let profileImage = profileImage else { return }
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_REF.child("profile_image").child(filename)
            
            storageRef.putData(uploadData,
                               metadata: nil) { (metadata, error) in
                                
                    if let error = error {
                        print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    }
                
                    storageRef.downloadURL { (downloadURL, error) in
                        
                        guard let profileImageURL = downloadURL?.absoluteString else {
                            return
                        }
                        
                        let dictionaryValues = ["name": name,
                                                "username": username,
                                                "email": email,
                                                "profileImageURL": profileImageURL,
                                                "birthday": "",
                                                "mobileCell": "",
                                                "additionalEmail": ""]
                        let values = [user?.user.uid: dictionaryValues]
                        
                        DB_REF.child("users").updateChildValues(values) { (error, ref) in
                            if error == nil {
                                print("Succesfuly created user and saved information to database")
                            }
                        }
                    }
            }
        }
    }
    
    func updateUser(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            let dictionaryValues = ["name": user.name,
                                    "username": user.username,
                                    "email": user.email,
                                    "profileImageURL": user.profileImageURL,
                                    "birthday": user.birthday ?? "",
                                    "mobileCell": user.mobileCell ?? "",
                                    "additionalEmail": user.additionalEmail ?? ""]
            let values = [currentUser.uid: dictionaryValues]
            // Save user info to database
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                print("Succesfuly updated information to database")
            })
        }
    }
    
    func updateProfileImage(user: User, profileImage: UIImage) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_REF.child("profile_image").child(filename)
            storageRef.putData(uploadData,
                               metadata: nil,
                               completion: { (metadata, error) in
                    if let error = error {
                        print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    }
                
                    storageRef.downloadURL(completion: { (downloadURL, error) in
                        guard let profileImageURL = downloadURL?.absoluteString else {
                            return
                        }
                        
                        let dictionaryValues = ["name": user.name,
                                                "username": user.username,
                                                "email": user.email,
                                                "profileImageURL": profileImageURL]
                        let values = [currentUser.uid: dictionaryValues]
                        
                        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                            print("Succesfuly updated profile picture")
                        })
                    })
            })
        }
    }
    
    func updateUserAddress(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            let values = try? ["shippingAddress": user.address.asDictionary()]
            Database.database().reference().child("users").child(currentUser.uid).updateChildValues(values ?? [:], withCompletionBlock: { (error, ref) in
                print("Succesfuly updated information to database")
            })
        }
    }
    
    func fetchCurrentUserAddress() {
        guard let currentUser = Auth.auth().currentUser else { return }
        Database.database().reference().child("users").child(currentUser.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String?, String> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            let address = user.address
            print(address, "address")
        }
    }
}
