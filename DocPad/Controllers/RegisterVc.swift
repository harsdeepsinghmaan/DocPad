//
//  RegisterVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 24/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import NKVPhonePicker
import MBProgressHUD


class RegisterVc: UIViewController,CountriesViewControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: NKVPhonePickerTextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var hud  = MBProgressHUD()
    var phonenumber = String()
    var countryCode = String()
    var firstName = String()
    var LastName = String()
    var UserName = String()
    var Password = String()
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = BaseUrl as! String
        txtPhoneNumber.phonePickerDelegate = self
        txtPhoneNumber.countryPickerDelegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtUserName.delegate = self
        txtPassword.delegate = self
        txtPhoneNumber.delegate = self

        
        // Setting initial custom country
        let country = Country.country(for: NKVSource(countryCode: "RU"))
        txtPhoneNumber.country = country
        
        
        // Setting custom format pattern for some countries
        txtPhoneNumber.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                           "IN": "## #### #########"]
        
    }
   
    
    // MARK: - Create Profile Api
    
    func callCreateProfileApi(_firstName: String,_LastName: String,_UserName: String,_Password: String,_countryCode: String,_phonenumber: String){
        hud.show(animated: true)
        let headers: [String:Any] = ["content-type": "application/json"]
        var postData =  Data()
        //        let str = String(format:"%d",_WeightId)
        let parameters = [
            "fname": _firstName,
            "lname": _LastName,
            "login": _UserName,
           "password": _Password,
            "isdcode": _countryCode,
            "phone": _phonenumber
            ] as [String : Any]
        
        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/users/\(createProfileApi)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hud.hide(animated: true)
                }
            } else {
                
                if(response != nil && data != nil ) {
                    do {
                         if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        {
                           
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                var dict = NSDictionary()
                                dict = json as NSDictionary
                                print(dict)
                                
                                if dict != nil {

                                       self.navigationController?.popViewController(animated: true)
                                }else{
                                    print("no data")
                                }
                            
                        }
                         }
                            
                        else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
                                let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        DispatchQueue.main.async {
                            self.hud.hide(animated: true)
                            let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
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
    
    // MARK: - Check Username Or LoginId Api
    
    func checkloginId(_login: String){
        hud.show(animated: true)
//        let headers: [String:Any] = ["X-Auth-Token": self.authToken]
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/users/\(validateloginidApi)=\(_login)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hud.hide(animated: true)
                }
            } else {
                
                if(response != nil && data != nil ) {
                    do {
                        if var json = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        {
                              print("\(String(describing: json))")
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                var result = json as String
                                
                            result =  result.replacingOccurrences(of: "\"", with: "")
                                
                                if result == "AlreadyTaken"{
                                    self.displayAlertMessage(messageToDisplay: "User Name Already Exist")
                                    
                                }else{
                                    self.callCreateProfileApi(_firstName: self.firstName, _LastName: self.LastName, _UserName: self.UserName, _Password: self.Password, _countryCode: self.countryCode, _phonenumber: self.phonenumber)
                                }
                                
                                
                                
                            }
                            
                        }
                            
                        else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
                                let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        DispatchQueue.main.async {
                            self.hud.hide(animated: true)
                            let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
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
    
    
    
    
    // MARK: - CountriesViewControllerDelegate Method
    
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country)")
        
    }
    
    
    // MARK: - Button Action
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        if txtPassword.text == "" {
            self.displayAlertMessage(messageToDisplay: "Please enter the password")
            
        }else if txtFirstName.text == "" {
            self.displayAlertMessage(messageToDisplay: "Please enter the firstname")
            
        } else if txtLastName.text == "" {
            self.displayAlertMessage(messageToDisplay: "Please enter the lastname")
            
        }else if txtUserName.text == "" {
            self.displayAlertMessage(messageToDisplay: "Please enter the username")
            
        }else if txtPhoneNumber.text == "" {
            self.displayAlertMessage(messageToDisplay: "Please enter the phone number")
            
        }
        else{
            
            
            if validate(password: txtPassword.text!) {
                countryCode = txtPhoneNumber.code!
                phonenumber = txtPhoneNumber.text
                firstName = txtFirstName.text!
                LastName = txtLastName.text!
                UserName = txtUserName.text!
                Password = txtPassword.text!
                
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                checkloginId(_login: UserName)
            }
            else {
                self.displayAlertMessage(messageToDisplay: "Password should contain one uppercase letter, lowercase letter and digit or specal character")
            }
        }
       
        
    }
    
    
    // MARK: - Validate Function
    
    func validate(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest2.evaluate(with: password) else { return false }
        
        return true
    }
    
    // MARK: - UIAlert Method
    
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


    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
