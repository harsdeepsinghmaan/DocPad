//
//  ViewAppointmentsVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class ViewAppointmentsVc: UIViewController , UIScrollViewDelegate {
    
    
  @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
  @IBOutlet weak var mainScrollVw: UIScrollView!
  @IBOutlet weak var lblCommingAppointment: UILabel!
  @IBOutlet weak var lblAppointmentHistory: UILabel!
  var checkLevel = "1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollVw.delegate = self
        
        lblAppointmentHistory.backgroundColor = (UIColor(red: 229/255.00, green: 75/255.00, blue: 5/255.00, alpha: 1.0))
        lblCommingAppointment.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
        lblCommingAppointment.isHidden = false
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }

        
    }
    
    
    // MARK: - Functions
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if  mainScrollVw.contentOffset == CGPoint(x: 375.0, y: 0.0){
            checkLevel = "2"
            self.changelblcolour()
        }
        else{
            checkLevel = "1"
            self.changelblcolour()
        }
    }
    
    
    func changelblcolour(){
        if checkLevel == "1"
        {
            
            lblCommingAppointment.isHidden = false
            //            lblSent.isHidden = true
            lblAppointmentHistory.backgroundColor = (UIColor(red: 229/255.00, green: 75/255.00, blue: 5/255.00, alpha: 1.0))
            lblCommingAppointment.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
        }
        if checkLevel == "2"{
            lblAppointmentHistory.isHidden = false
            //            lblInbox.isHidden = true
            lblAppointmentHistory.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
            lblCommingAppointment.backgroundColor = (UIColor(red: 229/255.00, green: 75/255.00, blue: 5/255.00, alpha: 1.0))
            
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func btnCommingAppointment(_ sender: Any) {
        mainScrollVw.contentOffset = CGPoint(x: 0.0, y: 0.0)
        //        scrollVwOfProfile.scrollToTop()
        checkLevel = "1"
        self.changelblcolour()
    }
    
    
    
    @IBAction func btnAppointmentHistory(_ sender: Any) {
        mainScrollVw.contentOffset = CGPoint(x: 375.0, y: 0.0)
        //        scrollVwLogin.scrollToTop()
        checkLevel = "2"
        self.changelblcolour()
    }
    
   
    
   @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
