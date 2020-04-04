//
//  TopCategory.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class TopCategory: UICollectionViewCell {
    
    static var identifier: String = "TopCategory"
    
    static var preferredSize: CGSize = CGSize(width: 110, height: 130)
    
    static var imageSize: CGFloat = 90

    var category: Category? {
        didSet {
            categoryName.text = category?.name
            downloadCategoryImage()
        }
    }
    
    let categoryImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .green
        iv.clipsToBounds = true
        iv.layer.cornerRadius = imageSize / 2
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: imageSize),
            iv.heightAnchor.constraint(equalToConstant: imageSize),
        ])
        return iv
    }()
    
    let categoryName: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.font = UIFont(name: "Arial", size: 12)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Loading..."
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMainContainer() {
        let sv = UIStackView(arrangedSubviews: [categoryImage, categoryName])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sv.topAnchor.constraint(equalTo: contentView.topAnchor),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            categoryName.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryName.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func downloadCategoryImage() {
        ProductsAPI.getCategoryImage(keywords: category!.name, onDone: setDownloadedImage)
    }
    
    func setDownloadedImage(image imgData: Data?) {
        guard let image = imgData else { return }
        categoryImage.image = UIImage(data: image)
    }
}
