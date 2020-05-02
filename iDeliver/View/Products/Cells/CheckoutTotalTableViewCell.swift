//
//  CheckoutTotalTableViewCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CheckoutTotalTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CheckoutTotalCell"
    
    private let priceFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        let content = NSMutableAttributedString(
            string: "Subtotal\nShipping\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ])
        content.append(NSAttributedString(
            string: "Total",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]))
        text.attributedText = content
        return text
    }()
    
    private let priceLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMainLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMainLayout() {
        selectionStyle = .none
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setProductSubtotal(products: [Product]) {
        let subtotal = products.reduce(0) { $0 + $1.price }
        let shipping = products.reduce(0) { $0 + $1.shipping }
        let subtotalContent = NSMutableAttributedString(
            string: priceFormatter.string(from: NSNumber(value: subtotal))! + "\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ])
        subtotalContent.append(NSAttributedString(
            string: priceFormatter.string(from: NSNumber(value: shipping))! + "\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]))
        subtotalContent.append(NSAttributedString(
            string: priceFormatter.string(from: NSNumber(value: shipping + subtotal))!,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]))
        priceLabel.attributedText = subtotalContent
    }
    
}
