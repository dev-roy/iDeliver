//
//  ConfirmedOrderViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Lottie
import UIKit

class ConfirmedOrderViewController: UIViewController {
    private let animationView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animation = Animation.named("16885-delivery")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        return view
    }()
    
    private let messageLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Your order has been confirmed and it's on the way!"
        text.font = UIFont.systemFont(ofSize: 30)
        text.numberOfLines = 0
        text.textAlignment = .center
        return text
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Back", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(onReturnPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
        setUpAnimation()
    }
    
    func setUpMain() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(animationView)
        view.addSubview(messageLabel)
        view.addSubview(returnButton)
        
        let margins = view.layoutMarginsGuide
        animationView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: 12).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        returnButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        returnButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        returnButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setUpAnimation() {
        animationView.play()
    }
    
    @objc
    func onReturnPressed() {
        navigationController?.popToRootViewController(animated: true)
    }

}
