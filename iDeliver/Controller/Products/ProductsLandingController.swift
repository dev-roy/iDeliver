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
    var data: [Int] = []//Array(0..<120)
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

    // MARK: View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()
        setUpMain()
        downloadScreenData()
        //displayCartBadge(1)
    }
    
    // MARK: Set Up
    func setUpTopBar() {
        setUpCartIcon()
        setUpSearchbar()
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
        if number == 0 { return }
        itemsInCartLabel.text = "\(number)"
        cartIcon.addSubview(itemsInCartLabel)
        
        NSLayoutConstraint.activate([
            itemsInCartLabel.rightAnchor.constraint(equalTo: cartIcon.rightAnchor),
            itemsInCartLabel.bottomAnchor.constraint(equalTo: cartIcon.bottomAnchor)
        ])
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

        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
    @objc func onCartPressed(sender: UIButton) {
        print("Cart icon pressed on landing")
    }

}

// MARK: Collection View Data Source & Delegation
extension ProductsLandingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + topCategories.count
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
    
    func navigateToListWithCategory(category cat: Category) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductsListController.storyBoardIdentifier) as! ProductsListController
        vc.category = cat
        navigationController?.pushViewController(vc, animated: true)
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
