//
//  PulseoximeterTvc.swift
//  DocPad
//
//  Created by DeftDeskSol on 22/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class PulseoximeterTvc: UITableViewCell {
    
    @IBOutlet weak var vwShedow: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwShedowDetail: UIView!
    @IBOutlet weak var vwMainDetail: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSpoValue: UILabel!
    @IBOutlet weak var lblPeakValue: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var vwTextVW: UIView!
    @IBOutlet weak var txtVW: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        vwShedow.layer.shadowColor = UIColor.black.cgColor
        vwShedow.layer.shadowOpacity = 1
        vwShedow.layer.shadowOffset = .zero
        vwShedow.layer.shadowRadius = 2
        
        
        vwShedowDetail.layer.shadowColor = UIColor.black.cgColor
        vwShedowDetail.layer.shadowOpacity = 1
        vwShedowDetail.layer.shadowOffset = .zero
        vwShedowDetail.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
