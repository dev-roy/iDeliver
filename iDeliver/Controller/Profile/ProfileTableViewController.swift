 //
//  ProfileTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 4/21/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
 
class ProfileTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Properties
    var user: User?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.roundImage()
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrentUserData()
    }
    
    // MARK: - Networking
    func fetchCurrentUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String?, Any> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
            self.nameLabel.text = user.name
            self.usernameLabel.text = user.username
            if let imageURL = user.profileImageURL {
                let url = URL(string: imageURL)
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.profileImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToName" {
            let controller = segue.destination as! NameTableViewController
            controller.user = self.user
        }
        if segue.identifier == "segueToPassword" {
            let controller = segue.destination as! PasswordTableViewController
            controller.user = self.user
        }
        if segue.identifier == "segueToShippingAddress" {
            let controller = segue.destination as! ShippingTableViewController
            controller.user = self.user
        }
        
        if segue.identifier == "segueToBillingAddress" {
            let controller = segue.destination as! BillingTableViewController
            controller.user = self.user
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirm Log Out", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive) { (action: UIAlertAction!) in
            UserNetworkManager.shared.logOutUser()
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }
 }
