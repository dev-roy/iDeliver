//
//  ShoppingCartListViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/16/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ShoppingCartListViewController: UIViewController {
    
    static let storyBoardIdentifier: String = "ShoppingCart"
    
    private var data = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Shopping Cart"
        getCartList()
    }
    
    func getCartList() {
        ProductsAPI.getShoppingCartItems { products in
            self.data = products
            print("Shopping cart items set")
        }
    }


}
