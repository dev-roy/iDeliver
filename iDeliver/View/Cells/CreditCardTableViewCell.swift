//
//  CreditCardTableViewCell.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardIssuerImageView: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    @IBOutlet weak var cardExpiration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
