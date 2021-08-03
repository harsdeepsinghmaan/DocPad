//
//  BodtDimensionCell.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class BodtDimensionCell: UITableViewCell ,UITextViewDelegate {
    
    var textChanged: ((String) -> Void)?
    
    
    @IBOutlet weak var vwShedow: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwShedowDetail: UIView!
    @IBOutlet weak var vwMainDetail: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBust: UILabel!
    @IBOutlet weak var lblChest: UILabel!
    @IBOutlet weak var lblHip: UILabel!
    @IBOutlet weak var lblHeadCircular: UILabel!
    @IBOutlet weak var lblLeftBicep: UILabel!
    @IBOutlet weak var lblLeftCalf: UILabel!
    @IBOutlet weak var lblLeftForearm: UILabel!
    @IBOutlet weak var lblLeftThigh: UILabel!
    @IBOutlet weak var lblLeftWrist: UILabel!
    @IBOutlet weak var lblRightBicep: UILabel!
    @IBOutlet weak var lblRightCalf: UILabel!
    @IBOutlet weak var lblRightForearm: UILabel!
    @IBOutlet weak var lblRightThigh: UILabel!
    @IBOutlet weak var lblRightWrist: UILabel!
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
        
        
        txtVW.delegate = self
        
    }
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textChanged = nil
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
