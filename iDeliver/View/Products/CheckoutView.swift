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
        table.separatorColor = .clear
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
        backgroundColor = .green
        setUpTable()
    }
    
    func setUpTable() {
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.register(ProductCheckoutTableViewCell.self, forCellReuseIdentifier: ProductCheckoutTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
