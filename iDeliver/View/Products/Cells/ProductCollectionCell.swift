//
//  ProductCollectionCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/24/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    // MARK: - Properties
    static var identifier: String = "ProductCollectionCell"
    static var preferredSize: CGSize = CGSize(width: 110, height: 130)
    static var imageSize: CGFloat = 90

    var model: Product? {
        didSet {
            nameLabel.text = model?.name
            downloadItemImage()
        }
    }
    
    // MARK: - Properties
    private let productImage: APIImage = {
        let iv = APIImage(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: imageSize),
            iv.heightAnchor.constraint(equalToConstant: imageSize),
        ])
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMain()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpMain() {
        let stackView = UIStackView(arrangedSubviews: [productImage, nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func downloadItemImage() {
        productImage.showSpinner()
        ProductsAPI.downloadImageData(from: model!.image) { (imgData: Data?) in
            DispatchQueue.main.async() { [unowned self] () in
                self.productImage.removeSpinner()
                let img = UIImage(data: imgData!)
                if img?.size == nil {
                    self.productImage.image = UIImage(systemName: "photo")
                    return
                }
                self.productImage.image = img
            }
        }
    }
}
