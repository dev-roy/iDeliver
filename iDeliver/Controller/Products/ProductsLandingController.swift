//
//  ProductsLandingController.swift
//  iDeliver
//
//  Created by Hugo Flores on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductsLandingController: UIViewController {
    
    // MARK: Variables
    var data: [Int] = []
    var sections = 1
    var topCategories: [Category] = []
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Your placeholder"
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
    
    let mainCollectionView: UICollectionView = {
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
        //displayCartBadge(1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
    
    func setUpSearchbar() {
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpMain() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(TopCategory.self, forCellWithReuseIdentifier: TopCategory.identifier)
        mainCollectionView.register(LandingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LandingHeaderView.identifier)

        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: Navigation
    func navigateToListWithCategory(category cat: Category) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductsListController.storyBoardIdentifier) as! ProductsListController
        vc.category = cat
        navigationController?.pushViewController(vc, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    func navigateToAllCategories() {
//        let vc = AllCategoriesViewController()
//        navigationController?.pushViewController(vc, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: AllCategoriesViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: Data Handlers
    func downloadScreenData() {
        let data = ProductsAPI.getMockTopCategories()
        topCategories = data
        ProductsAPI.getNumberOfItemsInCart { nbr in
            self.displayCartBadge(nbr)
        }
    }
    
    // MARK: Action Handlers
    @objc
    func onCartPressed(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ShoppingCartListViewController.storyBoardIdentifier)
        navigationController?.pushViewController(vc!, animated: true)
    }

}

// MARK: Collection View Data Source & Delegation
extension ProductsLandingController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + topCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LandingHeaderView.identifier, for: indexPath) as! LandingHeaderView
        view.descriptionLabel.text = "Top Categories"
        view.setActionLabel(text: "View All")
        view.onActionTap = navigateToAllCategories
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0...(topCategories.count - 1):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategory.identifier, for: indexPath) as! TopCategory
            cell.category = topCategories[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProductsLandingController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...(topCategories.count - 1):
            let catg = topCategories[indexPath.row]
            navigateToListWithCategory(category: catg)
        default:
            print("Selection handler not implemented")
        }
    }
}

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
