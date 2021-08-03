//
//  CareRecordsCell.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class CareRecordsCell: UITableViewCell {
    
    @IBOutlet weak var vwShedow: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnDownloadFile: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwShedow.layer.shadowColor = UIColor.black.cgColor
        vwShedow.layer.shadowOpacity = 1
        vwShedow.layer.shadowOffset = .zero
        vwShedow.layer.shadowRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
