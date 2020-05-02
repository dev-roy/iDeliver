//
//  AllCategoriesViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/22/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class AllCategoriesViewController: UIViewController {
    // MARK: - Properties
    static let storyBoardIdentifier: String = "AllCategories"
    private var categories: [Category] = []

    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TopCategory.self, forCellWithReuseIdentifier: TopCategory.identifier)
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "All Categories"
        setUpMain()
        downloadData()
    }
    
    // MARK: - Layout Setup
    func setUpMain() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let margins = view.safeAreaLayoutGuide
        collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func downloadData() {
        ProductsAPI.getAllCategories { [unowned self] data in
            guard let data = data else { return }
            self.categories = data
            self.collectionView.reloadData()
        }
    }
    
    func navigateToListWithCategory(category cat: Category) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProductsListController.storyBoardIdentifier) as! ProductsListController
        vc.category = cat
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AllCategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategory.identifier, for: indexPath) as! TopCategory
        cell.category = categories[indexPath.row]
        return cell
    }
}

extension AllCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catg = categories[indexPath.row]
        navigateToListWithCategory(category: catg)
    }
}

extension AllCategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TopCategory.preferredSize
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
