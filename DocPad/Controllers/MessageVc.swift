//
//  MessageVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit

class MessageVc: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    @IBOutlet weak var mainScrollVw: UIScrollView!
    @IBOutlet weak var lblInbox: UILabel!
    @IBOutlet weak var lblSent: UILabel!
    
    
    var viewHasMovedToRight = Bool()
    var checkLevel = "1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         mainScrollVw.delegate = self
//        lblSent.isHidden = true
        lblSent.backgroundColor = (UIColor(red: 27/255.00, green: 97/255.00, blue: 192/255.00, alpha: 1.0))
        lblInbox.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
        lblInbox.isHidden = false
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
            btnBackOutlet.setImage(#imageLiteral(resourceName: "menuWhite_Img"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function
    
    func changelblcolour(){
        if checkLevel == "1"
        {
            
            lblInbox.isHidden = false
            //            lblSent.isHidden = true
            lblSent.backgroundColor = (UIColor(red: 27/255.00, green: 97/255.00, blue: 192/255.00, alpha: 1.0))
            lblInbox.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
        }
        if checkLevel == "2"{
            lblSent.isHidden = false
            //            lblInbox.isHidden = true
            lblSent.backgroundColor = (UIColor(red: 250/255.00, green: 250/255.00, blue: 250/255.00, alpha: 1.0))
            lblInbox.backgroundColor = (UIColor(red: 27/255.00, green: 97/255.00, blue: 192/255.00, alpha: 1.0))
            
        }
    }
    
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
    
    
    // MARK: - Button Action
    
    @IBAction func btnInbox(_ sender: Any) {
        mainScrollVw.contentOffset = CGPoint(x: 0.0, y: 0.0)
//        scrollVwOfProfile.scrollToTop()
        checkLevel = "1"
        self.changelblcolour()
        
    }
    
    @IBAction func btnSent(_ sender: Any) {
        mainScrollVw.contentOffset = CGPoint(x: 375.0, y: 0.0)
//        scrollVwLogin.scrollToTop()
        checkLevel = "2"
        self.changelblcolour()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    }



