//
//  ProductsLandingController.swift
//  iDeliver
//
//  Created by Field Employee on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductsLandingController: UIViewController {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Your placeholder"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    let cartButton: UIButton = {
        let img = UIImage(named: "shopcart")
        let btn = UIButton()
        btn.setImage(img, for: .normal)
        btn.imageView!.contentMode = .scaleAspectFit
        btn.imageView!.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Set up")
        setUpTopBar()
    }
    
    func setUpTopBar() {
        setUpCartIcon()
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpCartIcon() {
        cartButton.addTarget(self, action: #selector(onCartPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let margins = navigationController?.navigationBar.layoutMargins
        NSLayoutConstraint.activate([
            cartButton.imageView!.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height - margins!.right * 2),
            cartButton.widthAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height + margins!.right)
        ])
    }
    
    @objc func onCartPressed(sender:UIBarButtonItem) {
        print("Here")
    }

}
