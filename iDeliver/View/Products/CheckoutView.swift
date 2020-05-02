//
//  CheckoutView.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CheckoutView: UIView {

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 10
        table.alwaysBounceVertical = false
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMain()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMain() {
        backgroundColor = .white
        setUpTable()
    }
    
    func setUpTable() {
        tableView.register(ProductCheckoutTableViewCell.self, forCellReuseIdentifier: ProductCheckoutTableViewCell.reuseIdentifier)
        tableView.register(CheckoutTotalTableViewCell.self, forCellReuseIdentifier: CheckoutTotalTableViewCell.reuseIdentifier)
        tableView.register(ButtonTableCell.self, forCellReuseIdentifier: ButtonTableCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        addSubview(tableView)
        let margins = layoutMarginsGuide
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
}
