//
//  ProductTableCellView.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductTableCellView: UITableViewCell {
    
    static var identifier: String = "product_cell"
    static var imageSize: CGFloat = 90
    private var cellMargins: CGFloat = 16

    var product: Product? {
        didSet {
            nameLabel.text = product?.name
            priceLabel.text = "$\(product!.price)"
            downloadItemImage()
            if product?.shipping == 0 {
                shippingLabel.text = "Free Shipping"
                return
            }
            shippingLabel.text = "+ $\(product!.shipping)"
        }
    }
    
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
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let shippingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpCell() {
        let lsv = UIStackView(arrangedSubviews: [nameLabel, priceLabel, shippingLabel])
        lsv.axis = .vertical
        lsv.alignment = .leading
        lsv.spacing = 8
        let sv = UIStackView(arrangedSubviews: [productImage, lsv])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellMargins),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellMargins),
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellMargins),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellMargins),
        ])
    }
    
    func downloadItemImage() {
        ProductsAPI.downloadImageData(from: product!.image) { (imgData: Data?) in
            let img = UIImage(data: imgData!)

            if img?.size == nil {
                self.productImage.image = UIImage(systemName: "photo")
                return
            }
            self.productImage.image = img
        }
    }
}
