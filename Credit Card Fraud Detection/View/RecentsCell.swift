//
//  RecentsCell.swift
//  Credit Card Fraud Detection
//
//  Created by Utkarsh Sharma on 14/03/21.
//

import UIKit

class RecentsCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
