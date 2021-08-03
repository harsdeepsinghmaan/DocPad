//
//  HomeVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class HomeVc: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {
    

    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
     var itemNameArray = ["RPM","Tele Medicine","Patient Engagement","Account Settings"]
    var itemImageArray = [#imageLiteral(resourceName: "vitals_Img"),#imageLiteral(resourceName: "teleMed"),#imageLiteral(resourceName: "dashboard_Icon"),#imageLiteral(resourceName: "accountSetting_Img")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
           self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
       self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Collection View Method
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return itemNameArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCvc
       cell.lblItemsName.text = itemNameArray[indexPath.row]
       cell.itemsImageVw.image = itemImageArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if ((indexPath.row == 0) && (indexPath.section == 0)){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "DashboardVc") as! DashboardVc
//             controller.viewHasMovedToRight = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else  if ((indexPath.row == 1) && (indexPath.section == 0)){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "HealthVc") as! HealthVc
//             controller.viewHasMovedToRight = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else
        if ((indexPath.row == 0) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "VitalsVc") as! VitalsVc
             controller.viewHasMovedToRight = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
//        else  if ((indexPath.row == 3) && (indexPath.section == 0)){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "AppointmentsVc") as! AppointmentsVc
//             controller.viewHasMovedToRight = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else  if ((indexPath.row == 4) && (indexPath.section == 0)){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "DocumentsVc") as! DocumentsVc
//             controller.viewHasMovedToRight = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else  if ((indexPath.row == 5) && (indexPath.section == 0)){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "MessageVc") as! MessageVc
//             controller.viewHasMovedToRight = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
        else  if ((indexPath.row == 1) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "VideoSessionVC")
            let navigationController = UINavigationController(rootViewController: controller!)
            sideMenuController?.rootViewController = navigationController
        }
        else  if ((indexPath.row == 2) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "PatientEngagementVC") as! PatientEngagementVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else  if ((indexPath.row == 3) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "AccountSettingVc") as!AccountSettingVc
            controller.viewHasMovedToRight = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    @IBAction func btnMenu(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: nil)
        
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //          let padding: CGFloat =  48
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if (screenWidth == 320){
            let cellSize = CGSize(width: ((self.view.frame.size.width/2) - 20), height: 200)
            return cellSize
        }
        else{
            let cellSize = CGSize(width: ((self.view.frame.size.width/2) - 20), height: 220)
            return cellSize
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if ((screenWidth == 375) && (screenHeight == 667)){
            return 40.0
        }
        else if ((screenWidth == 414)  && (screenHeight == 736)) {
            return 60.0
        }
        else if screenWidth == 375{
            return 80.0
        }
        else if (screenWidth == 414 ){
            return 120.0
        }
        else if (screenWidth == 320){
            return 20.0
        }
        else{
            return 40.0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if ((screenWidth == 375) && (screenHeight == 667)) {
            return UIEdgeInsets(top: 20,left: 10,bottom: 20,right: 10 )
        }
        else if ((screenWidth == 414)  && (screenHeight == 736)) {
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 ) //top, left, bottom, right
        }
        else  if screenWidth == 375{
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 ) //top, left, bottom, right
        }
        else if (screenWidth == 414 ){
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 )
        }
        else if (screenWidth == 320){
            return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10 )
        }
        else{
            return UIEdgeInsets(top: 20,left: 10,bottom: 20,right: 10 ) //top, left, bottom, right
        }
        
    }
    
    
}
