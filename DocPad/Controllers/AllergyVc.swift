//
//  AllergyVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class AllergyVc: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table View Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVw.dequeueReusableCell(withIdentifier: "allergyCell") as! AllergyTvc
      
        if indexPath.row == 0{
            cell.dotVw.backgroundColor = UIColor.red
        }
        else if indexPath.row == 1 {
            cell.dotVw.backgroundColor = UIColor.green
        }
        else if indexPath.row == 2 {
            cell.dotVw.backgroundColor = UIColor.yellow
        }
        else{
            cell.dotVw.backgroundColor = UIColor.blue
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVw.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Button Action 
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
