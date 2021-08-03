//
//  CareDocumentVC.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class CareDocumentVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    
 @IBOutlet weak var tableVW: UITableView!
 @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVW.separatorStyle = .none
        tableVW.delegate = self
        tableVW.dataSource = self
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        return 1
        }
        else
        {
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareDocumentCell") as! CareDocumentCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVW.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 64))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 15, width: headerView.frame.width-20, height: 30)
        
        let labelLine = UILabel()
        labelLine.frame = CGRect.init(x: 10, y: 55, width: headerView.frame.width-20, height: 2)
        
        label.text = "Augest 16"
        
        label.textColor = UIColor(red: 0.0/255, green: 148.0/255, blue: 127.0/255, alpha: 1.0)
        labelLine.backgroundColor = UIColor(red: 0.0/255, green: 148.0/255, blue: 127.0/255, alpha: 1.0)
        
        headerView.backgroundColor = UIColor.white
       
        headerView.addSubview(label)
        headerView.addSubview(labelLine)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    
     // MARK: - Button Action
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

}
