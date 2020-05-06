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
    
    func logOutUser() {
        try? Auth.auth().signOut()
    }
    
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
    
    func updateShippingAddress(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            let values = try? ["shippingAddress": user.shippingAddress.asDictionary()]
            Database.database().reference().child("users").child(currentUser.uid).updateChildValues(values ?? [:], withCompletionBlock: { (error, ref) in
                print("Succesfuly updated shipping address information to database")
            })
        }
    }
    
    func updateBillingAddress(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            let values = try? ["billingAddress": user.billingAddress.asDictionary()]
            Database.database().reference().child("users").child(currentUser.uid).updateChildValues(values ?? [:], withCompletionBlock: { (error, ref) in
                print("Succesfuly updated billing address information to database")
            })
        }
    }
    
    func updateCreditCardInfo(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Auth.auth().updateCurrentUser(currentUser) { (error) in
            if let error = error {
                print("Failed to update with error: ", error.localizedDescription)
                return
            }
            let values = try? ["creditCardInfo": user.creditCard.asDictionary()]
            Database.database().reference().child("users").child(currentUser.uid).updateChildValues(values ?? [:], withCompletionBlock: { (error, ref) in
                print("Succesfuly updated credit card information to database")
            })
        }
    }
    
    func fetchCurrentUserCreditCardInfo(user: User, completion: @escaping(_ address: CreditCard) -> ()) {
        DB_REF.child("users").child(user.uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String?, Any> else { return }
            guard let creditCardInfo = dictionary["creditCardInfo"] as? Dictionary<String?, Any> else { return }
            guard let cardNumber = creditCardInfo["cardNumber"] as? String else { return }
            guard let expirationMonth = creditCardInfo["expirationMonth"]  else { return }
            guard let expirationYear = creditCardInfo["expirationYear"] else { return }
            guard let cvc = creditCardInfo["cvc"] as? String else { return }
            guard let zipCode = creditCardInfo["zipCode"] as? String else { return }
            guard let cardHolderName = creditCardInfo["cardHolderName"] as? String else { return }
            let creditCard = CreditCard(cardNumber: cardNumber, expirationMonth: expirationMonth as! UInt, expirationYear: expirationYear as! UInt, cvc: cvc, zipCode: zipCode, cardHolderName: cardHolderName)
            completion(creditCard)
        }
    }
    
    func fetchCurrentUserAddress(user: User, completion: @escaping(_ address: Address) -> ()) {
        DB_REF.child("users").child(user.uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String?, Any> else { return }
            guard let address = dictionary["shippingAddress"] as? Dictionary<String?, Any> else { return }
            guard let street1 = address["street1"] as? String else { return }
            guard let street2 = address["street2"] as? String else { return }
            guard let city = address["city"] as? String  else { return }
            guard let state = address["state"] as? String else { return }
            guard let zipCode = address["zipCode"] as? String else { return }
            guard let countryOrRegion = address["countryOrRegion"] as? String else { return }
            let shippingAddress = Address(street1: street1, street2: street2, city: city, state: state, zipCode: zipCode, countryOrRegion: countryOrRegion)
            completion(shippingAddress)
        }
    }
}
