//
//  CreditCardTableViewCell.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardIssuerImageView: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    @IBOutlet weak var cardExpiration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
