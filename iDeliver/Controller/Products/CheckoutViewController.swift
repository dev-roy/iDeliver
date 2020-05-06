//
//  CheckoutViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

class CheckoutViewController: UIViewController {
    var products = [Product]()
    private let viewObj = CheckoutView()
    private var shippingAddress: Address?
    
    private enum Sections: Int, CaseIterable {
        case products
        case location
        case total
        case confirm
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
        getUser()
    }
    
    func setUpMain() {
        title = "Checkout"
        view = viewObj
        viewObj.tableView.dataSource = self
    }
    
    func navigateToLocationPicker() {
        let controller = LocationPickerViewController()
        controller.onLocationPicked = setDeliveryLocation(address:)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func getUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String?, Any> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            print(user)
        }
    }
    
    func setDeliveryLocation(address: Address) {
        shippingAddress = address
        viewObj.updateTableAt(indexPath: IndexPath(row: 0, section: Sections.location.rawValue))
    }
}

extension CheckoutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.products.rawValue: return products.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.products.rawValue: return getProductCell(tableView, cellForRowAt: indexPath)
        case Sections.location.rawValue: return getLocationCell(tableView, cellForRowAt: indexPath)
        case Sections.total.rawValue: return getTotalCell(tableView, cellForRowAt: indexPath)
        case Sections.confirm.rawValue: return getButtonCell(tableView, cellForRowAt: indexPath)
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Implement Me"
            return cell
        }
    }
    
    func getProductCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ProductCheckoutTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCheckoutTableViewCell.reuseIdentifier) as! ProductCheckoutTableViewCell
        cell.model = products[indexPath.row]
        return cell
    }
    
    func getTotalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CheckoutTotalTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTotalTableViewCell.reuseIdentifier) as! CheckoutTotalTableViewCell
        cell.setProductSubtotal(products: products)
        return cell
    }
    
    func getButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ButtonTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableCell.reuseIdentifier) as! ButtonTableCell
        cell.setButtonTitle("Confirm") {
            print("Implement confirmed action")
        }
        return cell
    }
    
    func getLocationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LocationTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableCell.reuseIdentifier) as! LocationTableCell
        cell.onPress = navigateToLocationPicker
        cell.setUpAddress(address: shippingAddress)
        return cell
    }
}
