//
//  ProductsLandingController.swift
//  iDeliver
//
//  Created by Hugo Flores on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import CoreData
import UIKit

class ProductsLandingController: UIViewController {
    // MARK: Properties
    var sections = 2
    var topCategories: [Category] = []
    var lastViewed: [Product] = []
    
    // MARK: Core Data context
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    // MARK: UI Components
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Search Items"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
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
    
    private let mainCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()
        setUpMain()
        downloadScreenData()
        getLastViewedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLastViewedItems()
    }
    
    // MARK: Set Up
    func setUpTopBar() {
        setUpCartIcon()
        setUpSearchbar()
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
    
    func displayCartBadge(_ number: Int) {
        if number <= 0 {
            itemsInCartLabel.removeFromSuperview()
            return
        }
        itemsInCartLabel.text = "\(number)"
        cartIcon.addSubview(itemsInCartLabel)
    }
    
    func setUpSearchbar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpMain() {
        view.addSubview(mainCollectionView)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(LandingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LandingHeaderView.identifier)
        mainCollectionView.register(TopCategory.self, forCellWithReuseIdentifier: TopCategory.identifier)
        mainCollectionView.register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.identifier)

        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
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
    
    // MARK: Navigation
    func navigateToListWithCategory(category cat: Category) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductsListController.storyBoardIdentifier) as! ProductsListController
        vc.category = cat
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToListWithQuery(query: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductsListController.storyBoardIdentifier) as! ProductsListController
        vc.query = query
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAllCategories() {
        let vc = storyboard?.instantiateViewController(withIdentifier: AllCategoriesViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func navigateToProductDetails(product: Product) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductDetailController.storyBoardIdentifier) as! ProductDetailController
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Data Handlers
    func getLastViewedItems() {
        do {
            let numberOfRecords = 8
            let fetchRequest = NSFetchRequest<CDProduct>(entityName: "CDProduct")
            let sort = NSSortDescriptor(key: #keyPath(CDProduct.dateAdded), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            let cdProducts = try context.fetch(fetchRequest)
            if cdProducts.isEmpty { return }
            var toDisplay = cdProducts
            if cdProducts.count > numberOfRecords {
                toDisplay = Array(toDisplay[0...(numberOfRecords - 1)])
            }
            let skus: [Int] = toDisplay.map { Int($0.sku) }
            if skus.first == lastViewed.first?.sku { return }
            downloadRecentViewedItems(skus: skus)
        } catch {
            fatalError("Failed to load CD Context")
        }
    }

    func downloadScreenData() {
        let data = ProductsAPI.getMockTopCategories()
        topCategories = data
        ProductsAPI.getNumberOfItemsInCart { [unowned self] nbr in
            self.displayCartBadge(nbr)
        }
    }
    
    func downloadRecentViewedItems(skus: [Int]) {
        if skus.isEmpty { return }
        ProductsAPI.getItemsBySKU(sku: skus) { products in
            DispatchQueue.main.async { [unowned self] () in
                guard let products = products else { return }
                self.lastViewed = products
                self.mainCollectionView.reloadSections(IndexSet(integer: 1))
            }
        }
    }
    
    // MARK: Action Handlers
    @objc
    func onCartPressed(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ShoppingCartListViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
    }

}

// MARK: Collection View Data Source
extension ProductsLandingController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return topCategories.count
        case 1: return lastViewed.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LandingHeaderView.identifier, for: indexPath) as! LandingHeaderView

        switch indexPath.section {
        case 0:
            view.setLabels(description: "Top Categories", action: "View All")
            view.onActionTap = navigateToAllCategories
            break
        case 1:
            if lastViewed.count == 0 { return view }
            view.setLabels(description: "Last Viewed")
        default:
            view.setLabels(description: "?")
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategory.identifier, for: indexPath) as! TopCategory
            cell.category = topCategories[indexPath.row]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.identifier, for: indexPath) as! ProductCollectionCell
            cell.model = lastViewed[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: Collection View Delegate
extension ProductsLandingController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: navigateToListWithCategory(category: topCategories[indexPath.row])
        case 1: navigateToProductDetails(product: lastViewed[indexPath.row])
        default: print("Selection handler not implemented")
        }
    }
}

// MARK: Collection View DelegateFlowLayout
extension ProductsLandingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...(topCategories.count - 1):
            return TopCategory.preferredSize
        default:
            let size = (view.frame.width) / 6
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

// MARK: Search Bar Delegate
extension ProductsLandingController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.endEditing(true)
        navigateToListWithQuery(query: query)
        searchBar.text = nil
    }
}
