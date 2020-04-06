//
//  ProductDetailController.swift
//  iDeliver
//
//  Created by Field Employee on 4/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController {
    
    static let storyBoardIdentifier: String = "ProductDetails"
    
    var product: Product? {
        didSet { }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
