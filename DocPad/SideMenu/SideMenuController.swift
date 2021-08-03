//
//  SideMenuController.swift
//  ShipCustomerDirect
//
//  Created by DeftDeskSol on 25/07/18.
//  Copyright © 2018 DeftDeskSol. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
  var userName : String = ""
  var imageurl = String()
    
  var imageArray = [#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "dashboard_Icon")]
 var nameArray = ["Dashboard","Health Records","Tele Medicine","Profile","Account Settings","Help","Logout"]
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       tableview.delegate = self
       tableview.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
//        profileIndexMethod()
        imageurl = UserDefaults.standard.value(forKey: "ImageUrl") as! String
        self.tableview.reloadData()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
       imageurl = UserDefaults.standard.value(forKey: "ImageUrl") as! String

    }
    
    
    
    // MARK: - Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.lblName.textColor = UIColor.black
        cell.lblName.text = nameArray[indexPath.row]
        cell.imgVw.image = imageArray[indexPath.row]
//        if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)){
//            cell.btnPlus.isHidden = false
//
//        }
//        else {
            cell.btnPlus.isHidden = true
     //   }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.estimatedRowHeight = 55
//        return UITableView.automaticDimension
        return 50
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerVw = Bundle.main.loadNibNamed("HeaderView", owner: self, options: [:])?.last as! HeaderView
//       headerVw.image_View.layer.cornerRadius = headerVw.image_View.frame.height/2
           headerVw.backgroundColor = UIColor.white
        if imageurl != ""{
          headerVw.profileImgVw.sd_setImage(with: URL(string: imageurl), placeholderImage: nil)
        }
        else{
            
        }
        
//        if let userNames = UserDefaults.standard.value(forKey: "user_Name") as? String{
//           headerVw.lbl_Name.text = userNames

//        }
        return headerVw
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "DashboardVc")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
            self.sideMenuController?.toggleLeftViewAnimated(nil)
        }

       else if indexPath.row == 1{
            let controller = storyboard?.instantiateViewController(withIdentifier: "HealthVc")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
        self.sideMenuController?.toggleLeftViewAnimated(nil)
        }
//       else if indexPath.row == 2{
//            let controller = storyboard?.instantiateViewController(withIdentifier: "AppointmentsVc")
//            let navigationController = UINavigationController(rootViewController: controller!)
//            sideMenuController?.rootViewController = navigationController
//        }
//        else if indexPath.row == 3{
//            let controller = storyboard?.instantiateViewController(withIdentifier: "DocumentsVc")
//            let navigationController = UINavigationController(rootViewController: controller!)
//            sideMenuController?.rootViewController = navigationController
//        }
//        else if indexPath.row == 4{
//            let controller = storyboard?.instantiateViewController(withIdentifier: "MessageVc")
//            let navigationController = UINavigationController(rootViewController: controller!)
//            sideMenuController?.rootViewController = navigationController
//        }
//        else if indexPath.row == 5{
////            let controller = storyboard?.instantiateViewController(withIdentifier: "VitalsVc")
////            let navigationController = UINavigationController(rootViewController: controller!)
////            sideMenuController?.rootViewController = navigationController
//        }
        else if indexPath.row == 2 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "VideoSessionVC")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
            self.sideMenuController?.toggleLeftViewAnimated(nil)
        }
        else if indexPath.row == 3 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileVc")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
            self.sideMenuController?.toggleLeftViewAnimated(nil)
        }
        else if indexPath.row == 4 {

            let controller = storyboard?.instantiateViewController(withIdentifier: "AccountSettingVc")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
            self.sideMenuController?.toggleLeftViewAnimated(nil)
        }
        else if indexPath.row == 5 {
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "AccountSettingVc")
//            let navigationController = UINavigationController(rootViewController: controller!)
//            sideMenuController?.rootViewController = navigationController
        }
        else if indexPath.row == 6 {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Log out?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
                UserDefaults.standard.set(false, forKey: "logged_in")
                UserDefaults.standard.synchronize()
                if #available(iOS 13.0, *) {
                    let login = self.storyboard?.instantiateViewController(identifier: "LoginVc") as? LoginVc
                    let del = UIApplication.shared.delegate as? AppDelegate
                    del?.window?.rootViewController = login
                } else {
                    // Fallback on earlier versions
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as? LoginVc
                    let del = UIApplication.shared.delegate as? AppDelegate
                    del?.window?.rootViewController = login
                }
                self.dismiss(animated: true, completion: nil)
            }
            let no = UIAlertAction(title: "No", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(yes)
            alert.addAction(no)
            
            self.present(alert, animated: true, completion: nil)
            
        }
         

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
