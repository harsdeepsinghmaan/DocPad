//
//  TableViewCell.swift
//  ShipCustomerDirect
//
//  Created by DeftDeskSol on 25/07/18.
//  Copyright © 2018 DeftDeskSol. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView! = nil
    @IBOutlet weak var lblName: UILabel! = nil
     @IBOutlet weak var btnPlus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.textColor = UIColor.white
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
