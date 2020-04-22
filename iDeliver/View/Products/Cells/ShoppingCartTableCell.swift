//
//  ShoppingCartTableCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/21/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

protocol ShoppingCartCellDelegate {
    func removeItemFromCart(indexPath: IndexPath)
}

class ShoppingCartTableCell: UITableViewCell {
    static var identifier: String = "cart_cell"
    var baseCell: ProductTableCellView?
    var delegate: ShoppingCartCellDelegate?
    var tabelView: UITableView? {
        return superview as? UITableView
    }
    
    private let removeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        btn.setTitle("Remove", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 8,left: 8,bottom: 8,right: 8)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseCell = ProductTableCellView(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpCell() {
        guard let baseCell = baseCell else { return }
        removeButton.addTarget(self, action: #selector(removeFromCart(sender:)), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [baseCell.contentView, removeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc
    func removeFromCart(sender: UIButton) {
        guard let indexPath = tabelView?.indexPath(for: self) else { return }
        delegate?.removeItemFromCart(indexPath: indexPath)
    }
}
