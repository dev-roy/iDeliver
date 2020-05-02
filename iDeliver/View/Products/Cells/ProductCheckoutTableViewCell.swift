//
//  ProductCheckoutTableViewCell.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductCheckoutTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProductCheckoutCell"
    private static let viewSpacing: CGFloat = 12
    
    var model: Product? {
        didSet {
            setUpData()
            downloadItemImage()
        }
    }
    
    private let priceFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E, d MMM"
        return df
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .top
        view.spacing = ProductCheckoutTableViewCell.viewSpacing
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: ProductCheckoutTableViewCell.viewSpacing, left: 0, bottom: ProductCheckoutTableViewCell.viewSpacing, right: 0)
        return view
    }()
    
    let productImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "photo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()
    
    private let productSummary: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Summary"
        text.numberOfLines = 0
        return text
    }()
    
    private let productPrice: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Price"
        text.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        return text
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMainLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMainLayout() {
        selectionStyle = .none
        stackView.addArrangedSubview(productImage)
        stackView.addArrangedSubview(productSummary)
        stackView.addArrangedSubview(productPrice)
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setUpData() {
        guard let model = model else { fatalError("No model for \(Self.reuseIdentifier)") }
        let summary = NSMutableAttributedString(
            string: model.name + "\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ])
        summary.append(NSAttributedString(
            string: Date.generateRandomDateRange(format: "Est. Delivery %@ - %@", withFormat: dateFormatter),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]))
        productSummary.attributedText = summary
        productPrice.text = priceFormatter.string(from: NSNumber(value: model.price))
    }
    
    func downloadItemImage() {
        guard let model = model else { fatalError("No model for \(Self.reuseIdentifier)") }
        ProductsAPI.downloadImageData(from: model.image) { (imgData: Data?) in
            let img = UIImage(data: imgData!)
            if img?.size == nil {
                self.productImage.image = UIImage(systemName: "photo")
                return
            }
            self.productImage.image = img
        }
    }

}
