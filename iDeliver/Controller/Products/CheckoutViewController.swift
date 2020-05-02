//
//  CheckoutViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    var products = [Product]()
    private let viewObj = CheckoutView()
    
    private enum Sections: Int, CaseIterable {
        case products
        case total
        case confirm
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
    }
    
    func setUpMain() {
        title = "Checkout"
        view = viewObj
        viewObj.tableView.dataSource = self
    }
}

extension CheckoutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.products.rawValue: return products.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.products.rawValue: return returnProductCell(tableView, cellForRowAt: indexPath)
        case Sections.total.rawValue: return returnTotalCell(tableView, cellForRowAt: indexPath)
        case Sections.confirm.rawValue: return returnButtonCell(tableView, cellForRowAt: indexPath)
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Implement Me"
            return cell
        }
    }
    
    func returnProductCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ProductCheckoutTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCheckoutTableViewCell.reuseIdentifier) as! ProductCheckoutTableViewCell
        cell.model = products[indexPath.row]
        return cell
    }
    
    func returnTotalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CheckoutTotalTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTotalTableViewCell.reuseIdentifier) as! CheckoutTotalTableViewCell
        cell.setProductSubtotal(products: products)
        return cell
    }
    
    func returnButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ButtonTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableCell.reuseIdentifier) as! ButtonTableCell
        cell.setButtonTitle("Confirm") {
            print("Implement confirmed action")
        }
        return cell
    }
}
