//
//  HealthVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class HealthVc: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource  {
    
    
    
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    var viewHasMovedToRight = Bool()
    var itemNameArray = ["Allergies","Medication","Immunization","Diagnoses","Procedures","Family History","Social History","Lab Result","Condition(PMH)"]
    var itemImageArray = [#imageLiteral(resourceName: "allergy_Img"),#imageLiteral(resourceName: "medication_Img"),#imageLiteral(resourceName: "immunization_Img"),#imageLiteral(resourceName: "diagnosis"),#imageLiteral(resourceName: "procedure"),#imageLiteral(resourceName: "familyHistory_Img"),#imageLiteral(resourceName: "history"),#imageLiteral(resourceName: "labResult_Img"),#imageLiteral(resourceName: "condition_Img")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        self.navigationController?.navigationBar.isHidden = true
        if viewHasMovedToRight == true{
            btnBackOutlet.setImage(#imageLiteral(resourceName: "back_Icon"), for: .normal)
        } else {
            btnBackOutlet.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Collection View Method
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return itemNameArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "healthCell", for: indexPath) as! HealthCvc
        cell.lblItemsName.text = itemNameArray[indexPath.row]
        cell.itemsImageVw.image = itemImageArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ((indexPath.row == 0) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "AllergyVc") as! AllergyVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 1) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "MedicationVc") as! MedicationVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 2) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "ImmunizationVc") as! ImmunizationVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 3) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "DiagnosesVc") as! DiagnosesVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 4) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "ProcedureVc") as! ProcedureVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 5) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "FamilyVc") as! FamilyVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 6) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "SocialHistoryVc") as! SocialHistoryVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 7) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "LabResultVc") as! LabResultVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 8) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "ConditionVc") as! ConditionVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    
     // MARK: - UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //          let padding: CGFloat =  48
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if (screenWidth == 320){
            let cellSize = CGSize(width: ((self.view.frame.size.width/3) - 20), height: 145)
            return cellSize
        }
        else{
            let cellSize = CGSize(width: ((self.view.frame.size.width/3) - 20), height: 161)
            return cellSize
        }
        
    }
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0.0
    //    }
    
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
    
    // MARK: - Button Action

    @IBAction func btnMenu(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
    }
    


