//
//  APIImage.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class APIImage: UIImageView {
    
    var vSpinner : UIView?
    
    private let viewColor: UIColor = UIColor(white: 0.0, alpha: 0.2)
    private var previousColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSpinner() {
        let spinnerView = UIView.init(frame: self.bounds)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        previousColor = backgroundColor
        backgroundColor = viewColor
        ai.startAnimating()
        
        spinnerView.addSubview(ai)
        addSubview(spinnerView)
        
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ai.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        backgroundColor = previousColor
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }

}
