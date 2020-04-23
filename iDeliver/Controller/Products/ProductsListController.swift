//
//  ProductsListController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductsListController: UITableViewController {
    // MARK: Properties
    static let storyBoardIdentifier: String = "ProductsList"
    private var products: [Product]? {
        didSet {
            if products?.count == 0 {
                let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height))
                let messageLabel = UILabel(frame: rect)
                messageLabel.text = category == nil ? "No Items Found" : "No Items For Category"
                messageLabel.textColor = .black
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "TrebuchetMS", size: 30)
                messageLabel.sizeToFit()

                tableView.backgroundView = messageLabel
                tableView.separatorStyle = .none
                return
            }
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }

    var category: Category? {
        didSet {
            spinnerView.showSpinner(in: view)
            setUpSearchByCategory()
            
        }
    }
    
    var query: String? {
        didSet {
            spinnerView.showSpinner(in: view)
            setUpSearchByQuery()
        }
    }
    
    // MARK: UI Components
    private let cartIcon: UIView = {
        let image = UIImageView(image: UIImage(systemName: "cart")!.withRenderingMode(.alwaysOriginal))
        image.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        return image
    }()
    
    private let itemsInCartLabel : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 18, y: 18, width: 15, height: 15))
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .center
        lbl.backgroundColor = .systemBlue
        lbl.layer.cornerRadius = 15/2
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    let spinnerView: SpinnerView = SpinnerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        //products = [Product]()
        setUpNavBar()
        //spinnerView.showSpinner(in: self.view)
        tableSetUp()
        ProductsAPI.getNumberOfItemsInCart { [unowned self] nbr in
            self.displayCartBadge(nbr)
        }
    }
    
    // MARK: - Set Up
    func setUpNavBar() {
        setUpCartIcon()
        NotificationCenter.default.addObserver(self, selector: #selector(onCartModified(_:)), name: Notification.Name(rawValue: NotificationEventsKeys.cartUpdated.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCartModified(_:)), name: Notification.Name(rawValue: NotificationEventsKeys.itemRemovedFromCart.rawValue), object: nil)
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
    }
    
    func tableSetUp() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func displayCartBadge(_ number: Int) {
        if number <= 0 {
            itemsInCartLabel.removeFromSuperview()
            return
        }
        itemsInCartLabel.text = "\(number)"
        cartIcon.addSubview(itemsInCartLabel)
    }
    
    // MARK: Notifications
    @objc
       func onCartModified(_ notification: Notification) {
           guard let data = notification.userInfo as? [String: Int] else { return }
           if let numberOfItems = data["itemsInCart"] {
               displayCartBadge(numberOfItems)
           }
           if let _ = data["itemToRemove"] {
               let current = Int(itemsInCartLabel.text ?? "0") ?? 0
               displayCartBadge(current - 1)
           }
       }
    
    // MARK: Data Handlers
    func setUpSearchByCategory() {
        title = category?.name
        ProductsAPI.getMockItemsByCategory(id: category!.id){ [unowned self] items in
            self.spinnerView.stopSpinner()
            self.products = items!
            self.tableView.reloadData()
        }
    }
    
    func setUpSearchByQuery() {
        guard let query = query else { return }
        title = "Search: \(query)"
        ProductsAPI.getMockItemsByQuery(query: query) { items in
            DispatchQueue.main.async { [unowned self] () in
                self.spinnerView.stopSpinner()
                self.products = items!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Action Handlers
    @objc func onCartPressed(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ShoppingCartListViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let products = products else { return 0 }
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let products = products else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableCellView.identifier, for: indexPath) as! ProductTableCellView
        cell.product = products[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products![indexPath.row]
        navigateToDetails(product: product)
    }
    
    func navigateToDetails(product: Product) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductDetailController.storyBoardIdentifier) as! ProductDetailController
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
}
