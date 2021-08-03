//
//  DiagnosesVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class DiagnosesVc: UIViewController , UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        tableVw.delegate = self
        tableVw.dataSource = self
        tableVw.backgroundColor = .white
        self.tableVw.separatorStyle = .none
    }
    
     // MARK: - Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVw.dequeueReusableCell(withIdentifier: "diagnosesCell") as! DiagnosesTvc
        
        if indexPath.row == 0{
            cell.lblName.text = "Glycozine Metabolism"
        }
        else if indexPath.row == 1 {
            cell.lblName.text = "Malaria"
        }
        else{
            cell.lblName.text = "Malaria"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVw.deselectRow(at: indexPath, animated: true)
    }
    
     // MARK: - Button Action 
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
