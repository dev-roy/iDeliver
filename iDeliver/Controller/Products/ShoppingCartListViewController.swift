//
//  ShoppingCartListViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/16/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ShoppingCartListViewController: UIViewController {
    static let storyBoardIdentifier: String = "ShoppingCart"
    private var data: [Product] = [] {
        didSet {
            if data.count == 0 {
                let rect = CGRect(origin: CGPoint(x: 0,y :0), size: view.bounds.size)
                let messageLabel = UILabel(frame: rect)
                messageLabel.text = "Add items to start filling your cart"
                messageLabel.textColor = .black
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "TrebuchetMS", size: 30)
                messageLabel.sizeToFit()

                tableView.backgroundView = messageLabel
                tableView.separatorStyle = .none
                navigationItem.rightBarButtonItem = nil
                return
            }
            setUpNavigationBar()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Shopping Cart"
        setUpTable()
        getCartList()
    }
    
    func setUpTable() {
        tableView.dataSource = self
        tableView.register(ShoppingCartTableCell.self, forCellReuseIdentifier: ShoppingCartTableCell.identifier)
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: .plain, target: self, action: #selector(onCheckout))
    }
    
    func getCartList() {
        ProductsAPI.getShoppingCartItems { [unowned self] products in
            self.data = products
            self.tableView.reloadData()
        }
    }

    @objc
    func onCheckout() {
        let controller = CheckoutViewController()
        controller.products = data
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension ShoppingCartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartTableCell.identifier, for: indexPath) as! ShoppingCartTableCell
        cell.delegate = self
        cell.baseCell?.product = data[indexPath.row]
        return cell
    }
}

extension ShoppingCartListViewController: ShoppingCartCellDelegate {
    func removeItemFromCart(indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
