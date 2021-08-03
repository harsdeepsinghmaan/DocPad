//
//  DashboardTvc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import Charts
class DashboardTvc: UITableViewCell {
    

    @IBOutlet weak var lineChart: LineChartView!
    
//    var lineChartEntry = [ChartDataEntry]()
//    var lineChartEntry2 = [ChartDataEntry]()
//    var lineChartEntry3 = [ChartDataEntry]()
//    
//    var total = NSMutableArray()
//    var total2 = NSMutableArray()
//    var total3 = NSMutableArray()
    
    
    @IBOutlet weak var lbeTitalChart: UILabel!
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var lbePul: UILabel!
    @IBOutlet weak var lbeSy: UILabel!
    
    @IBOutlet weak var lbeDia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
