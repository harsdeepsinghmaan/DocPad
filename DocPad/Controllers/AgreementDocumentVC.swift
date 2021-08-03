//
//  AgreementDocumentVC.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class AgreementDocumentVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgreementDocumentCell") as! AgreementDocumentCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVW.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Button Action
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    


}
