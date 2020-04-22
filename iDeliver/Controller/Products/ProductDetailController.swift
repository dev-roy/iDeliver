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
    
    private let priceFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currencyISOCode
        return nf
    }()
    
    private let dateFormatter: DateFormatter = {
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
            checkIfItemIsInCart()
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
    
    private let mainContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productDataContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return view
    }()
    
    private let addToCartButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitle("Add to cart", for: .normal)
        btn.addTarget(self, action: #selector(addItemToCart), for: .touchUpInside)
        return btn
    }()
    
    private let purchaseButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.setTitle("Purchase now", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(purchaseItem), for: .touchUpInside)
        return btn
    }()
    
    private let cartIcon: UIView = {
        let image = UIImageView(image: UIImage(systemName: "cart")!.withRenderingMode(.alwaysOriginal))
        image.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        return image
    }()
    
    private let itemsInCartLabel : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 18, y: 18, width: 15, height: 15))
        //lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .center
        lbl.backgroundColor = .systemBlue
        lbl.layer.cornerRadius = 15/2
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    private let itemActionsContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        return view
    }()

    private let spinnerView = SpinnerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCartIcon()
        setUpScrollView()
        setUpImage()
        setUpProductDataStackView()
        
        ProductsAPI.getNumberOfItemsInCart { [unowned self] nbr in
            self.displayCartBadge(nbr)
        }
    }
    
    func setUpCartIcon() {
        let testBtn = UIButton(type: .custom)
        testBtn.addSubview(cartIcon)
        testBtn.addTarget(self, action: #selector(onCartPressed), for: .touchUpInside)
        let cart = UIBarButtonItem(customView: testBtn)
        
        navigationItem.rightBarButtonItem = cart
        
        NSLayoutConstraint.activate([
            cartIcon.centerYAnchor.constraint(equalTo: testBtn.centerYAnchor),
            cartIcon.centerXAnchor.constraint(equalTo: testBtn.centerXAnchor),
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(onCartModified(_:)), name: Notification.Name(rawValue: NotificationEventsKeys.itemRemovedFromCart.rawValue), object: nil)
    }
    
    @objc
    func onCartModified(_ notification: Notification) {
        guard let data = notification.userInfo as? [String: Int] else { return }
        if let sku = data["itemToRemove"] {
            let current = Int(itemsInCartLabel.text ?? "0") ?? 0
            displayCartBadge(current - 1)
            if sku == product?.sku {
                setUpItemActions(isItemInCart: false)
            }
        }
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
            mainContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),

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
        
        productDataContainer.addArrangedSubview(nameLabel)
        productDataContainer.addArrangedSubview(middleView)
        productDataContainer.addArrangedSubview(arrivalLabel)
        mainContainer.addArrangedSubview(productDataContainer)
        mainContainer.addArrangedSubview(itemActionsContainer)
    }
    
    func setUpItemActions(isItemInCart: Bool) {
        itemActionsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if !isItemInCart {
            itemActionsContainer.addArrangedSubview(addToCartButton)
            itemActionsContainer.addArrangedSubview(purchaseButton)
            return
        }
        
        let stringContent = NSMutableAttributedString(string: "Item already in cart 🛍\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        stringContent.append(NSAttributedString(string: "Continue shoppping or check out by pressing the cart icon", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        let content = UITextView()
        content.attributedText = stringContent
        content.textAlignment = NSTextAlignment.center
        content.isScrollEnabled = false
        content.layer.borderColor = UIColor.systemBlue.cgColor
        content.layer.borderWidth = 1
        content.layer.cornerRadius = 12
        itemActionsContainer.addArrangedSubview(content)
    }
    
    func setUpImage() {
        mainContainer.addArrangedSubview(productImage)
        
        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            productImage.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            productImage.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }
    
    func downloadItemImage() {
        ProductsAPI.downloadImageData(from: product!.image) { [unowned self] (imgData: Data?) in
            let img = UIImage(data: imgData!)

            if img?.size == nil {
                self.productImage.image = UIImage(systemName: "photo")
                return
            }
            self.productImage.image = img
        }
    }
    
    func displayCartBadge(_ number: Int) {
        if number == 0 { return }
        itemsInCartLabel.text = "\(number)"
        cartIcon.addSubview(itemsInCartLabel)
    }
    
    func checkIfItemIsInCart() {
        ProductsAPI.isItemInCart(sku: product!.sku) { [unowned self] isInCart in
            self.setUpItemActions(isItemInCart: isInCart)
        }
    }
    
    // MARK: Action Handlers
    @objc
    func onCartPressed(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ShoppingCartListViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc
    func addItemToCart(sender: UIButton) {
        spinnerView.showSpinner(in: view)
        ProductsAPI.addItemToCart(itemSKU: product!.sku) {
            ProductsAPI.getNumberOfItemsInCart { [unowned self] nbr in
                NotificationCenter.default.post(name: Notification.Name(NotificationEventsKeys.cartUpdated.rawValue), object: self, userInfo: ["itemsInCart": nbr])
                self.displayCartBadge(nbr)
                self.setUpItemActions(isItemInCart: true)
                self.spinnerView.stopSpinner()
            }
        }
    }
    
    @objc
    func purchaseItem(sender: UIButton) {
        print("Purchase item now")
    }

}
