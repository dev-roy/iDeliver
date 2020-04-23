//
//  LandingHeaderView.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/22/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class LandingHeaderView: UICollectionReusableView {
    static var identifier: String = "LandingHeader"
    var onActionTap: (() -> ())?
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Loading..."
        label.numberOfLines = 1
        return label
    }()
    
    let actionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 6, left: 16, bottom: 0, right: 16)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMain()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setUpMain() {
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setActionLabel(text: String) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onActionLabelTapped))
        actionLabel.isUserInteractionEnabled = true
        actionLabel.addGestureRecognizer(tap)
        actionLabel.text = text
        stackView.addArrangedSubview(actionLabel)
    }
    
    @objc
    func onActionLabelTapped(sender: UITapGestureRecognizer) {
        if let onActionTap = onActionTap { onActionTap() }
    }
}
