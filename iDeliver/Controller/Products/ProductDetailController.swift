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
    
    let priceFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currencyISOCode
        return nf
    }()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E, d MMM"
        return df
    }()
    
    var product: Product? {
        didSet {
            nameLabel.text = product?.name
            let range = Date.randomDateRange()
            let startDate = dateFormatter.string(from: range.start)
            let endDate = dateFormatter.string(from: range.end)
            arrivalLabel.text = String(format: "Est. Delivery %@ - %@", startDate, endDate)
            priceLabel.text = priceFormatter.string(from: NSNumber(value: product!.price))//String(product!.price)
            shippingLabel.text = product!.shipping == 0
                ? "Free Shipping!"
                : String(format: "+%@ Shipping", priceFormatter.string(from: NSNumber(value: product!.shipping))!)
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
        imgView.backgroundColor = UIColor.randomGreen()
        return imgView
    }()
    
    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let shippingLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 14)
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
    
    let mainContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        scrollView.addSubview(mainContainer)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainContainer.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor),
            mainContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0),

            mainContainer.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setUpProductDataStackView() {
        let bestPriceLabel = UILabel()
        bestPriceLabel.text = "or Best Offer"
        bestPriceLabel.font = UIFont.systemFont(ofSize: 12)
        bestPriceLabel.textColor = .gray
        let middleLeftView = UIStackView(arrangedSubviews: [priceLabel, bestPriceLabel])
        middleLeftView.axis = .vertical
        
        let middleView = UIStackView(arrangedSubviews: [middleLeftView, shippingLabel])
        middleView.axis = .horizontal
        middleView.spacing = 8
        
        productDataContainer.backgroundColor = .green
        mainContainer.addArrangedSubview(productDataContainer)
        productDataContainer.addArrangedSubview(nameLabel)
        productDataContainer.addArrangedSubview(middleView)
        productDataContainer.addArrangedSubview(arrivalLabel)

        NSLayoutConstraint.activate([
            productDataContainer.leftAnchor.constraint(equalTo: mainContainer.leftAnchor, constant: 16),
            productDataContainer.rightAnchor.constraint(equalTo: mainContainer.rightAnchor, constant: -16),
        ])
    }
    
    func setUpImage() {
        mainContainer.addArrangedSubview(productImage)
        
        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            productImage.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
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

}
