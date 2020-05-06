//
//  LocationTableCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class LocationTableCell: UITableViewCell {
    static let reuseIdentifier = "LocationTableCell"
    var onPress: (() -> Void)?
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 12
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        let content = NSMutableAttributedString(
            string: "Ship To",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ])
        text.attributedText = content
        text.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        return text
    }()
    
    private let contentLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 12)
        text.numberOfLines = 0
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMainLayout()
        setUpTapRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMainLayout() {
        accessoryType = .disclosureIndicator
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(contentLabel)
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setUpTapRecognizer() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        stackView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func onTap() {
        guard let onPress = onPress else { return }
        onPress()
    }
    
    func setUpAddress(address: Address?) {
        guard let location = address else {
            contentLabel.text = "Pick a location for delivering the product(s)"
            return
        }
        contentLabel.text = "\(location.street1), \(location.street2)\n\(location.state), \(location.city)\n\(location.countryOrRegion)"
    }

}
