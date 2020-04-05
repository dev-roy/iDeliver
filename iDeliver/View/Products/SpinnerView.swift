//
//  SpinnerView.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    
    private let spinnerBackdropColor: UIColor = UIColor(white: 0.0, alpha: 0.2)
    
    let spinner: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func showSpinner(in view: UIView) {
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = spinnerBackdropColor
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalTo: view.widthAnchor),
            spinner.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    
    func stopSpinner() {
        spinner.backgroundColor = nil
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

}
