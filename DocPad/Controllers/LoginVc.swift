//
//  LoginVc.swift
//  DocPad
//
//  Created by Vikram on 21/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import LGSideMenuController
import MBProgressHUD

class LoginVc: UIViewController , UITextFieldDelegate{
    

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var authToken = String()
    var imageurl = String()
    var personID = Int()
    
    var personDict = NSDictionary()
    var persontype = NSDictionary()
    var hud  = MBProgressHUD()
    var dataDict = NSMutableDictionary()
    var guestuser = String()
    var relationType1 = String()
    var relationType2 = String()
    var relativeName2 = String()
    var state = String()
    var zip = NSNumber()
    var type = String()
    var datenTime = Int()
    var fullName = String()
    var email = String()
    var url = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.delegate = self
        txtPassword.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        url = BaseUrl
    }
    // MARK: - Login Api
    
     func callLoginApi(){
        hud.show(animated: true)
        var postData =  Data()
         let headers = [ "content-Type": "application/x-www-form-urlencoded"]
         var password = String()
         var user = String()
        
        password = self.txtPassword.text!
        user = self.txtUsername.text!
        
        postData = NSMutableData(data: "username=\(user)&password=\(password)".data(using: String.Encoding.utf8)!) as Data
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/users/\(loginApi)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hud.hide(animated: true)
                }
            } else {
                
                if(response != nil && data != nil ) {
//                    print(String.init(data: data!, encoding: .utf8))
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                var dict = NSDictionary()
                                dict = json as NSDictionary
                                print(dict)
                                if dict["status"] as? String != "UNAUTHORIZED" {
                                    self.personDict = dict.value(forKey: "person") as! NSDictionary
                                    self.persontype = self.personDict.value(forKey: "persontype") as! NSDictionary
                                    
                                    self.dataDict = NSMutableDictionary.init(dictionary: self.personDict)
                                    if let Type = self.persontype.value(forKey: "type") as? String{
                                        self.type = Type
                                    }
                                    else{
                                        self.type = ""
                                    }
                                    if let guestuser = dict.value(forKey: "guestuser") as? String{
                                        self.guestuser = guestuser
                                    }
                                    else{
                                        self.guestuser = ""
                                    }
                                    if let relationType1 = self.personDict.value(forKey: "relationType1") as? String{
                                        self.relationType1 = relationType1
                                    }
                                    else{
                                        self.relationType1 = ""
                                    }
                                    if let relationType2 = self.personDict.value(forKey: "relationType2") as? String{
                                        self.relationType2 = relationType2
                                    }
                                    else{
                                        self.relationType2 = ""
                                    }
                                    if let relativeName2 = self.personDict.value(forKey: "relativeName2") as? String{
                                        self.relativeName2 = relativeName2
                                    }
                                    else{
                                        self.relativeName2 = ""
                                    }
                                    if let state = self.personDict.value(forKey: "state") as? String{
                                        self.state = state
                                    }
                                    else{
                                        self.state = ""
                                    }
                                    if let zip = self.personDict.value(forKey: "zip") as? NSNumber{
                                        print(zip)
                                    }
                                    
                                    if let zip = self.personDict.value(forKey: "zip") as? NSNumber{
                                        self.zip = zip
                                    }
                                    else{
                                        self.zip = 0
                                    }
                                    
                                    self.authToken = dict.value(forKey: "authtoken") as! String
                                    if self.personDict.value(forKey: "imageurl") as? String != nil{
                                        self.imageurl = self.personDict.value(forKey: "imageurl") as! String
                                    }
                                    else{
                                        print("no image")
                                        self.imageurl = ""
                                    }
                                    
                                    self.personID = self.personDict.value(forKey: "personID") as! Int
                                   self.fullName = self.personDict.value(forKey: "fullName") as! String
                                    self.email = self.personDict.value(forKey: "email") as? String ?? ""
                                    
                                    self.dataDict.setValue(self.authToken, forKey: "authtoken")
                                    self.dataDict.setValue(self.relationType1, forKey: "relationType1")
                                    self.dataDict.setValue(self.relationType2, forKey: "relationType2")
                                    self.dataDict.setValue(self.relativeName2, forKey: "relativeName2")
                                    self.dataDict.setValue(self.guestuser, forKey: "guestuser")
                                    self.dataDict.setValue(self.state, forKey: "state")
                                    self.dataDict.setValue(self.zip, forKey: "zip")
                                    self.dataDict.setValue(self.type, forKey: "type")
                                    self.dataDict.setValue(self.fullName, forKey: "fullName")
                                    self.dataDict.setValue(self.email, forKey: "email")
                                    self.dataDict.setValue(self.imageurl, forKey: "ImageUrl")
                               
                                    do{
                                        var jsonData = Data()
                                        if #available(iOS 11.0, *) {
                                            jsonData = try NSKeyedArchiver.archivedData(withRootObject: self.dataDict, requiringSecureCoding: true)
                                        } else {
                                            // Fallback on earlier versions
                                            jsonData =  NSKeyedArchiver.archivedData(withRootObject: self.dataDict)
                                        }
                                        UserDefaults.standard.set(jsonData, forKey: "LoginDict")
                                        UserDefaults.standard.synchronize()
                                        
                                    }
                                    catch{
                                        print("error")
                                    }
                                   

                                    UserDefaults.standard.set(self.authToken, forKey: "AuthToken")
                                    UserDefaults.standard.set(self.imageurl, forKey: "ImageUrl")
                                    UserDefaults.standard.set(self.personID, forKey: "PersonID")
                                    UserDefaults.standard.set(self.fullName, forKey: "fullName")
                                    UserDefaults.standard.set(self.email, forKey: "email")
//                                    UserDefaults.standard.set(self.id, forKey: "Id")
                                    
                                    UserDefaults.standard.set(true, forKey: "logged_in")
                                    UserDefaults.standard.synchronize()
                                    let leftController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController")
                                    
                                    let homecontroller = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc")
                                    let navigationController = UINavigationController(rootViewController: homecontroller!)
                                    
                                    let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                                                  leftViewController: leftController,
                                                                                  rightViewController: nil)
                                    
                                    sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width - 70
                                    sideMenuController.leftViewPresentationStyle = .slideAbove
                                    
                                    sideMenuController.rightViewWidth = 100.0
                                    sideMenuController.leftViewPresentationStyle = .slideAbove
                                    
                                    let del = UIApplication.shared.delegate as! AppDelegate
                                    del.window?.rootViewController = sideMenuController
                                } else {
                                    let alert = UIAlertController.init(title: "Incorrect login", message:"Username or password is incorrect", preferredStyle: .alert)
                                    let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(ok)
                                    self.present(alert, animated: true, completion: nil)

                                }
                                
                            }
                        }
                        else {
//                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                            print("Error could not parse JSON: \(String(describing: jsonStr))")
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                let alert = UIAlertController.init(title: "Incorrect login", message:"Username or password is incorrect", preferredStyle: .alert)
                                let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch let parseError {
                        print(parseError)
// let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        DispatchQueue.main.async {
                            self.hud.hide(animated: true)
                            let alert = UIAlertController.init(title: "Incorrect login", message:"Username or password is incorrect", preferredStyle: .alert)
                            let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
        
        dataTask.resume()
        
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

    // MARK: - Button Action
    
    @IBAction func btnLogin(_ sender: Any) {
        if txtUsername.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter the username")
            
        }
        else if txtPassword.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter the password")
        }
        else if((txtUsername.text == "") && (txtPassword.text == "")){
            self.displayAlertMessage(messageToDisplay: "please enter the username")
        }
        else
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
           self.callLoginApi()
        }
        
    }
   
    
    
    @IBAction func btnRegister(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "RegisterVc") as!RegisterVc
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings_segue" {
            let controller = segue.destination as! AccountSettingVc
            controller.viewHasMovedToRight = true
        }
    }
}
