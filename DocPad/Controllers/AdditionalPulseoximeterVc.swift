//
//  AdditionalPulseoximeterVc.swift
//  DocPad
//
//  Created by Vikram on 21/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class AdditionalPulseoximeterVc: UIViewController,UITextFieldDelegate , UITextViewDelegate {
    var personID = Int()
    var source = String()
    var authToken = String()
    
    var putOrPost = Bool()
    var dictDate = NSDictionary()
    
    var datenTime = NSNumber()
    var deviceId = String()
    var deviceIdInt = Int()
    var enteredBy = Int()
    var IdStr = String()
    var isNotified = Bool()
    var note = String()
    var patientId = Int()
    var patientName = String()
    var pr = Int()
    var spo2 = Int()
    var stringdatentime = String()
    var listArray  = NSArray()
    var dateString = String()
    var delayTime = String()
    
    var hud  = MBProgressHUD()
    var url = String()
    
    let dataArray = NSMutableArray()
    
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    
    @IBOutlet weak var txtVWHeight: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtVWComment: UITextView!
    @IBOutlet weak var txtSpo: UITextField!
    @IBOutlet weak var txtPulse: UITextField!
    @IBOutlet weak var txtReadingDate: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        url = BaseUrl as! String
        txtSpo.delegate = self
        txtPulse.delegate = self
        txtReadingDate.delegate = self
        txtVWComment.delegate = self
        txtVWComment.text = "Comment"
       // txtVWComment.textColor = UIColor.white
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        
        
         if putOrPost
        {
            if (dictDate.value(forKey: "datenTime") as? NSNumber) != nil{
                
                if  var weight = (dictDate.value(forKey: "datenTime") as? NSNumber)
                {
                    datenTime = weight
                }
                else
                {
                    datenTime = 0
                }
            }
            else{
                datenTime = 0
            }
            
            if (dictDate.value(forKey: "deviceId") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "deviceId") as? String)
                {
                    deviceId = weight
                }
                else
                {
                    deviceId = ""
                }
            }
            
            else if (dictDate.value(forKey: "deviceId") as? Int) != nil {
                if  var weight = (dictDate.value(forKey: "deviceId") as? Int)
                {
                    deviceIdInt = weight
                }
                else
                {
                    deviceIdInt = 0
                }
            }
            else{
                deviceIdInt = 0
            }
            
            if (dictDate.value(forKey: "enteredBy") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "enteredBy") as? Int)
                {
                    enteredBy = weight
                }
                else
                {
                    enteredBy = 0
                }
            }
            else{
                enteredBy = 0
            }
            
            if (dictDate.value(forKey: "id") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "id") as? String)
                {
                    IdStr = weight
                }
                else
                {
                    IdStr = ""
                }
            }
            else{
                IdStr = ""
            }
            
            if (dictDate.value(forKey: "note") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "note") as? String)
                {
                    note = weight
                }
                else
                {
                    note = ""
                }
            }
            else{
                note = ""
            }
            
            if (dictDate.value(forKey: "patientId") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "patientId") as? Int)
                {
                    patientId = weight
                }
                else
                {
                    patientId = 0
                }
            }
            else{
                patientId = 0
            }
            
            if (dictDate.value(forKey: "patientName") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "patientName") as? String)
                {
                    patientName = weight
                }
                else
                {
                    patientName = ""
                }
            }
            else{
                patientName = ""
            }
            
            if (dictDate.value(forKey: "pr") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "pr") as? Int)
                {
                    pr = weight
                    
                }
                else
                {
                    pr = 0
                }
            }
            else{
                pr = 0
            }
            
            if (dictDate.value(forKey: "spo2") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "spo2") as? Int)
                {
                    spo2 = weight
                    
                }
                else
                {
                    spo2 = 0
                }
            }
            else{
                spo2 = 0
            }
            
            if (dictDate.value(forKey: "stringdatentime") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "stringdatentime") as? String)
                {
                    stringdatentime = weight
                }
                else
                {
                    stringdatentime = ""
                }
            }
            else{
                stringdatentime = ""
            }
         
        }
        else
            
        {
            
        }
        
        if putOrPost
        {
            
            self.txtSpo.text = String (spo2)
            self.txtPulse.text =  String (pr)
            
            if note == ""{
                
                self.txtVWComment.text = "Comment"
            }
            else{
                self.txtVWComment.text =  note
            }
            
            let timeStamp = datenTime
            let timeDouble = Double(timeStamp)
            let unixTimeStamp: Double = timeDouble / 1000.0
            let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
            let dateString = dateFormatter.string(from: exactDate)
            self.txtReadingDate.text = dateString
        }
        else
        {
            self.txtSpo.text = ""
            self.txtPulse.text = ""
            self.txtReadingDate.text = ""
            self.txtVWComment.text =  "Comment"
        }
        
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        self.navigationController?.navigationBar.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        self.adjustTextViewHeight()

    }
    

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    // MARK: UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSpo{
            self.txtSpo.resignFirstResponder()
            return true
        }
        if textField == txtPulse{
            self.txtPulse.resignFirstResponder()
            return true
        }
        if textField == txtReadingDate{
            self.txtReadingDate.resignFirstResponder()
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if putOrPost{
            self.txtReadingDate.isUserInteractionEnabled = false
            
        }
        else{
            if textField == txtReadingDate{
                self.txtReadingDate = textField
                
                // Create a date picker for the date field.
                let picker = UIDatePicker()
                picker.datePickerMode = .date
                picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
                
                // If the date field has focus, display a date picker instead of keyboard.
                // Set the text to the date currently displayed by the picker.
                textField.inputView = picker
                textField.text = formatDateForDisplay(date: picker.date)
            }
            else {
                textField.inputView = nil
                textField.reloadInputViews()
            }
            
        }
        
        
        
    }
    
    
    // MARK: UITextView Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Comment"
        {
            txtVWComment.text = ""
        }
        else
        {
            
        }
       // txtVWComment.textColor = UIColor.white
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if txtVWComment.text.isEmpty
        {
            txtVWComment.text = "Comment"
          //  txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
            
        }
        self.adjustTextViewHeight()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if txtVWComment.text.isEmpty
        {
            txtVWComment.text = "Comment"
          //  txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comment"
        {
            txtVWComment.text = ""
        }
        else
        {
            
            
        }
       // txtVWComment.textColor = UIColor.white
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVWComment.text.isEmpty
        {
            txtVWComment.text = "Comment"
         //   txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
        }
        
    }
    
    // // MARK:  Adjust TextView Height Method
    func adjustTextViewHeight() {
        let fixedWidth = self.txtVWComment.frame.size.width
        let newSize = self.txtVWComment.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height < 130
        {
            self.txtVWHeight.constant = newSize.height
            self.view.layoutIfNeeded()
        }
        else
        {
            self.txtVWComment.isScrollEnabled = true
        }
        
    }
    // MARK: UIDatePicker Methods
    
    @objc func updateDateField(sender: UIDatePicker) {
        txtReadingDate.text = formatDateForDisplay(date: sender.date)
    }
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: date)
    }
    
    // MARK: Back Button

    // MARK: Back Button

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:  Save Button

    @IBAction func Save(_ sender: Any) {
        
        if putOrPost
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.PulseeoximetterApi()
        }
        else
        {
            if !UserDefaults.standard.bool(forKey: "DelayBool"){
            if txtSpo.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Spo2")
            }
            else if txtPulse.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Pulse rate")
            }
            else if txtReadingDate.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
            }
            else
            {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                self.callPulseeoximetterRecordApi()
            }
                
        }else{
                checkDelayTime()
            }
        }
    }
    
    // MARK: Post Pulseeoximetter Api
    func callPulseeoximetterRecordApi()
    {
        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        source = UserDefaults.standard.value(forKey: "fullName") as! String
        
        let Spo = Int(self.txtSpo.text!)
        let Pulse = Int(self.txtPulse.text!)
        let strDate = self.txtReadingDate.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
        
        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
        
        var Note = ""
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }
        
        // convert to Integer
        let myInt = timeInterval
        
        let parameters = [
            "patientId": personID,
            "datenTime": myInt,
            "spo2": Spo as Any,
            "pr": Pulse as Any,
            "enteredBy": 1,
            "deviceId": "",
            "note": Note] as [String : Any]

        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/pulseoximeter")! as URL,
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
                            self.navigationController?.popViewController(animated: true)
                            }
                        }
                            
                        else {
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                            }
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
                        DispatchQueue.main.async {
                            self.hud.hide(animated: true)
                        }
                        
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

    // MARK: PUT Pulseeoximetter Api

    func PulseeoximetterApi()
    
    {

        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String

        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        
//        let strDate = self.txtReadingDate.text
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
//
//        let someDate = dateFormatter.date(from: strDate!)
//        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
//
//        // convert to Integer
//        let myInt = Int(timeInterval)
        
        let myInt = datenTime
        
        let Spo = Int(self.txtSpo.text!)
        let Pulse = Int(self.txtPulse.text!)
        
        var Note = String()
        
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }

        
        var id123 = self.IdStr.replacingOccurrences(of: "'", with: "")


        let parameters = [
            "id": id123,
            "datenTime": myInt,
            "spo2": Spo as Any,
            "pr": Pulse as Any,
            "patientId": patientId,
            "enteredBy": enteredBy,
            "isNotified": false,
            "deviceId": "",
            "note": Note,
            "visitId": "",
            "patientName": patientName,
            "visitdate": "",
            "stringdatentime": stringdatentime
            ] as [String : Any]

        
        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            
            //try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
        }
        catch {
            
        }
        

        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/pulseoximeter/\(id123)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "PUT"
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
                                    let alert = UIAlertController(title: "Successs", message:
                                        "Pulseoximeter data has been updated successfully", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.PulseoximeterList_pdate))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }else{
                                    print("no data")
                                }
                                
                 
                            }

                        }

                        else {
                            
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                            }
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
                        DispatchQueue.main.async {
                            self.hud.hide(animated: true)
                        }
                        
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
    
   func checkDelayTime() {
    let dateFormatter1 : DateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = Date()
    let dateString1 = dateFormatter1.string(from: date)
    let interval = date.timeIntervalSince1970
    
    
    
    
    var currentDateObj = dateString1
    var shiftDateFieldObj = dateString
    
    var dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var currentDate: Date? = dateFormatter3.date(from: currentDateObj)
    
    var dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var shiftDate: Date? = dateFormatter2.date(from: shiftDateFieldObj)
    
    
    var timeDifferenceBetweenDates: TimeInterval? = nil
    if let currentDate = currentDate {
    timeDifferenceBetweenDates = currentDate.timeIntervalSince(shiftDate!)
    }
    
    delayTime = UserDefaults.standard.value(forKey: "DelayTime") as! String
    
    var IntDelayTime = Double()
    IntDelayTime = Double(delayTime)!
    var InttimeDifferenceBetweenDates = Double()
    InttimeDifferenceBetweenDates = Double(timeDifferenceBetweenDates!)
    
    if IntDelayTime <= InttimeDifferenceBetweenDates{
        if txtSpo.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Spo2")
        }
        else if txtPulse.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Pulse rate")
        }
        else if txtReadingDate.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
        }
        else
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.callPulseeoximetterRecordApi()
        }
    
    }
    else{
    let alert = UIAlertController(title: "", message:
    "Please wait for \(delayTime) seconds", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.pulseoximeterBackAlert))
    
    self.present(alert, animated: true, completion: nil)
    }
    
    
    }
    
    func pulseoximeterBackAlert(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
   // MARK: Display Alert
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
    
    // MARK: PulseoximeterList Update Method
    func PulseoximeterList_pdate(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    
}



