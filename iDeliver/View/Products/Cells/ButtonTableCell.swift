//
//  ButtonTableCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ButtonTableCell: UITableViewCell {
    static let reuseIdentifier = "ButtonTableCell"
    private var action: (() -> Void)?
    
    private let button: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMainLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpMainLayout() {
        selectionStyle = .none
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
        contentView.addSubview(button)
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setButtonTitle(_ title: String, withAction action: @escaping () -> Void) {
        button.setTitle(title, for: .normal)
        self.action = action
    }
    
    @objc
    func onButtonPressed(sender: UIButton) {
        guard let action = action else { return }
        action()
    }
}
