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
        didSet {
            nameLabel.text = product?.name
            arrivalLabel.text = "Something"
            priceLabel.text = String(product!.price)
            shippingLabel.text = String(product!.shipping)
            downloadItemImage()
        }
    }
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let productImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .red
        return imgView
    }()
    
    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let shippingLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let arrivalLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let productDataContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCartIcon()
        setUpScrollView()
        setUpImage()
        setUpProductDataStackView()
    }
    
    func setUpCartIcon() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart")!.withRenderingMode(.alwaysOriginal),
        style: .plain, target: self, action: #selector(onCartPressed))
    }
    
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(productDataContainer)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            productDataContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            productDataContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            productDataContainer.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor),
            productDataContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0),

            productDataContainer.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setUpProductDataStackView() {
        let bestPriceLabel = UILabel()
        bestPriceLabel.text = "or Best Offer"
        let middleLeftView = UIStackView(arrangedSubviews: [priceLabel, bestPriceLabel])
        middleLeftView.axis = .vertical
        
        let middleView = UIStackView(arrangedSubviews: [middleLeftView, shippingLabel])
        middleView.axis = .horizontal
        
        productDataContainer.addArrangedSubview(nameLabel)
        productDataContainer.addArrangedSubview(middleView)
        productDataContainer.addArrangedSubview(arrivalLabel)
        /*
        NSLayoutConstraint.activate([
            productDataContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            productDataContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            productDataContainer.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 24),
        ])
        */
    }
    
    func setUpImage() {
        productDataContainer.addArrangedSubview(productImage)
        
        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: productDataContainer.leftAnchor),
            productImage.rightAnchor.constraint(equalTo: productDataContainer.rightAnchor),
            productImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
    }
    
    func downloadItemImage() {
        ProductsAPI.downloadImageData(from: URL(string: product!.image)!) { (imgData: Data?) in
            let img = UIImage(data: imgData!)

            if img?.size == nil {
                self.productImage.image = UIImage(systemName: "photo")
                return
            }
            self.productImage.image = img
        }
    }
    
    // MARK: Action Handlers
    @objc func onCartPressed(sender: UIBarButtonItem) {
        print("Cart pressed on product detail")
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
