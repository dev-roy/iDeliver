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
        case location
        case subtotal
        case total
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
        case Sections.products.rawValue:
            return products.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.products.rawValue: return returnProductCell(tableView, cellForRowAt: indexPath)
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
}
