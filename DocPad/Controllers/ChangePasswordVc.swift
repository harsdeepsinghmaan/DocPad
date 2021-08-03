//
//  ChangePasswordVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 23/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

//import UIKit
//import MBProgressHUD
//
//class ChangePasswordVc: UIViewController {
//
//  @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
//    var personID = Int()
//    var authToken = String()
//    var hud  = MBProgressHUD()
//
//    @IBOutlet weak var txtNewPassword: UITextField!
//
//    @IBOutlet weak var txtConfirmPassword: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
//            self.heightOfNavigationbar.constant = 80
//        }
//        else{
//            self.heightOfNavigationbar.constant = 64
//        }
//        self.navigationController?.navigationBar.isHidden = true
//        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
//        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
//        // Do any additional setup after loading the view.
//    }
//
//    @IBAction func btnBack(_ sender: Any) {
//
//            self.navigationController?.popViewController(animated: true)
//
//
//
//    }
//
//    func putChangePasswordApi(_personID: Int , _changePassword: String){
//        hud.show(animated: true)
//        let headers: [String:Any] = ["X-Auth-Token": self.authToken]
//        let request = NSMutableURLRequest(url: NSURL(string: "http://40.79.35.122:8081/emrmega/api/users/\(_personID)?password=\(_changePassword)")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 100.0)
//        request.httpMethod = "PUT"
//        request.allHTTPHeaderFields = headers as? [String : String]
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                DispatchQueue.main.async {
//                    self.hud.hide(animated: true)
//                }
//            } else {
//
//                if(response != nil && data != nil ) {
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
//                        {
//                            DispatchQueue.main.async {
//                                self.hud.hide(animated: true)
//
//                                var dict = NSDictionary()
//                                dict = json as NSDictionary
//                                print(dict)
//
//                                if dict != nil {
//                                    UserDefaults.standard.set(false, forKey: "logged_in")
//                                    UserDefaults.standard.synchronize()
//                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
//                                    self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//
//                                }
//                                else{
//                                    self.displayAlertMessage(messageToDisplay: "Please try after some time")
//                                }
//
//
//
//                            }
//
//                        }
//
//                        else {
//                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                            print("Error could not parse JSON: \(String(describing: jsonStr))")
//                            DispatchQueue.main.async {
//                                self.hud.hide(animated: true)
//                                let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
//                                let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
//                                alert.addAction(ok)
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                    } catch let parseError {
//                        print(parseError)
//                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
//                        DispatchQueue.main.async {
//                            self.hud.hide(animated: true)
//                            let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
//                            let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
//                            alert.addAction(ok)
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        })
//
//        dataTask.resume()
//    }
//
//    @IBAction func btnSave(_ sender: Any) {
//        if txtNewPassword.text == "" {
//            self.displayAlertMessage(messageToDisplay: "Please enter the password")
//
//        }
//        else if txtConfirmPassword.text == ""{
//            self.displayAlertMessage(messageToDisplay: "Please enter the password")
//
//        }
//        else if ((txtNewPassword.text == "") && (txtConfirmPassword.text == "")) {
//            self.displayAlertMessage(messageToDisplay: "Please enter the password")
//
//
//        }
//        else if ((txtNewPassword.text != txtConfirmPassword.text)&&(txtNewPassword.text != "") && (txtConfirmPassword.text != "")) {
//            self.displayAlertMessage(messageToDisplay: "Please check the password")
//
//        }
//        else{
//            if validate(password: txtNewPassword.text!) == true{
//                var changePassword = txtNewPassword.text
//                hud = MBProgressHUD.showAdded(to: view, animated: true)
//                putChangePasswordApi(_personID: personID, _changePassword: changePassword!)
//            }
//            else {
//                self.displayAlertMessage(messageToDisplay: "Password should contain one uppercase letter, lowercase letter and digit or specal character")
//            }
//        }
//
//
//
//
//    }
//
//    func validate(password: String) -> Bool {
//        let capitalLetterRegEx  = ".*[A-Z]+.*"
//        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
//        guard texttest.evaluate(with: password) else { return false }
//
//        let numberRegEx  = ".*[0-9]+.*"
//        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
//        guard texttest1.evaluate(with: password) else { return false }
//
//        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
//        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
//        guard texttest2.evaluate(with: password) else { return false }
//
//        return true
//    }
//    func displayAlertMessage(messageToDisplay: String)
//    {
//        let alertController = UIAlertController(title: "", message: messageToDisplay, preferredStyle: .alert)
//
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//
//            // Code in this block will trigger when OK button tapped.
//            print("Ok button tapped");
//
//        }
//
//        alertController.addAction(OKAction)
//
//        self.present(alertController, animated: true, completion:nil)
//    }
//
//}
