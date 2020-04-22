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
    private var data = [Product]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Shopping Cart"
        setUpNavigationBar()
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
            print("Data fetched: \(products.count)")
        }
    }

    @objc
    func onCheckout() {
        print("To Checkout")
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
