//
//  AccountSettingVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import DropDown

class AccountSettingVc: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var txtVideoUrl: UITextField!
    
    @IBOutlet weak var lbeSeconds: UILabel!
    @IBOutlet weak var lbeTopEnter: UILabel!
    @IBOutlet weak var txtDelayTime: UITextField!
    var viewHasMovedToRight = Bool()
    var url = String()
    var delayTime = String()
    let dropDown = DropDown()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "ViewMoved"){
            self.txtDelayTime.isEnabled = true
            //black
            lbeSeconds.textColor = UIColor.black
            lbeTopEnter.textColor = UIColor.black
            
        }
        else{
            lbeSeconds.textColor = UIColor.gray
            lbeTopEnter.textColor = UIColor.gray
            self.btnBackOutlet.isHidden = false
            

        }
        if let delay = UserDefaults.standard.value(forKey: "DelayTime") as? String {
            self.txtDelayTime.text = delay
        }
        self.navigationController?.navigationBar.isHidden = true
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
        
        if UserDefaults.standard.bool(forKey: "CheckUrl") {
            self.btnBackOutlet.isHidden = false
        }
        else {
            self.btnBackOutlet.isHidden = true
        }
        
        txtUrl.delegate = self
        txtDelayTime.delegate = self
       
        if UserDefaults.standard.value(forKey: "URL") != nil {
            var str = UserDefaults.standard.value(forKey: "URL") as! String
            self.txtUrl.text = str.replacingOccurrences(of: "/api", with: "")
        }
    }
    
    
    // MARK: - Button Action
    
    
    @IBAction func SelectURL(_ sender: Any) {
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = .init(x: 0, y: 35)
        dropDown.anchorView = (sender as! AnchorView)  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Pharmacy 1", "Pharmacy 2","Pharmacy 3"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtUrl.text = "http://40.79.35.122:8081/emrmega/api"
            
            
            self.dropDown.hide()
            
        }
        dropDown.show()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        delayTime = txtDelayTime.text!
        
        if delayTime != ""{
            
            UserDefaults.standard.set(delayTime, forKey: "DelayTime")
            UserDefaults.standard.set(true, forKey: "DelayBool")
            UserDefaults.standard.synchronize()
        }
        else{
            UserDefaults.standard.set("", forKey: "DelayTime")
            UserDefaults.standard.synchronize()
        }
        
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    
    
   
    @IBAction func btnSaveUrl(_ sender: Any) {
        delayTime = txtDelayTime.text!
        
        if delayTime != ""{
            
            UserDefaults.standard.set(delayTime, forKey: "DelayTime")
            UserDefaults.standard.set(true, forKey: "DelayBool")
            UserDefaults.standard.synchronize()
        }
        else{
            UserDefaults.standard.set("", forKey: "DelayTime")
            UserDefaults.standard.synchronize()
        }
        if txtUrl.text != ""{
            url = txtUrl.text!
            url.append(contentsOf: "/api")
            UserDefaults.standard.set(url, forKey: "URL")
            UserDefaults.standard.set(true, forKey: "CheckUrl")
            UserDefaults.standard.set(false, forKey: "ViewMoved")
            UserDefaults.standard.synchronize()
            BaseUrl = url
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVc") as!LoginVc
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            displayAlertMessage(messageToDisplay: "Please enter the url")
        }
        if txtVideoUrl.text?.replacingOccurrences(of: " ", with: "") != "" {
            UserDefaults.standard.set(txtVideoUrl.text, forKey: "VideoServer")
            UserDefaults.standard.synchronize()
        }
        
        
    }
    
    // MARK: - UIAlert Function
    
    
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

}
