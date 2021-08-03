//
//  CholestrolVC.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit

class CholestrolVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var height = CGFloat ()
    var models: [String] = []
    
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
        models = (0...100).map { _ in randomInt(min: 2, max: 10) }.map(Lorem.sentences)
    }
    
    
    // MARK: - Table View Delegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CholestrolCell") as! CholestrolCell
        
        cell.txtVW.text = models[indexPath.row]
        
        cell.textChanged {[weak tableView, weak self] newText in
            self?.models[indexPath.row] = newText
            
            
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return models[indexPath.row]
            .heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 14))
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        
//        tableView.reloadRows(at: [indexPath], with: .automatic)
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
    
    
    
    private func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    
    // MARK: - Button Action
   
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnGraph(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "LineChartVc") as!LineChartVc
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
