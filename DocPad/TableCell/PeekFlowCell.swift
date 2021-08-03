//
//  PeekFlowCell.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class PeekFlowCell: UITableViewCell ,UITextViewDelegate {
    
    var textChanged: ((String) -> Void)?
    
    
    @IBOutlet weak var vwShedow: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwShedowDetail: UIView!
    @IBOutlet weak var vwMainDetail: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFav1InLtrs: UILabel!
    @IBOutlet weak var lblFav6InLtrs: UILabel!
    @IBOutlet weak var lblPeakInLtrs: UILabel!
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
