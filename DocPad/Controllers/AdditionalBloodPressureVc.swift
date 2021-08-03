//
//  AdditionalBloodPressureVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 08/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift


class AdditionalBloodPressureVc: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    var authToken = String()
    var personID = Int()
    var source = String()
    var hud  = MBProgressHUD()
    var note = String()
    
    
    var putOrPost = Bool()
    var dictDate = NSDictionary()
    
    var bpId = Int()
    var systolic = Int()
    var diastolic = Int()
    var pulse = Int()
    var enteredBy = Int()
    var datenTime = NSNumber()
    var url = String()
    var listArray  = NSArray()
    var dateString = String()
    var delayTime = String()
    var type = String()
    var display = String()
    
    
    
    
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtxVWComment: UITextView!
    @IBOutlet weak var txtSystolic: UITextField!
    @IBOutlet weak var txtdiastolic: UITextField!
    @IBOutlet weak var txtPulse: UITextField!
    @IBOutlet weak var txtReadingDate: UITextField!
    @IBOutlet weak var txtVWHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        url = BaseUrl as! String
        txtSystolic.delegate = self
        txtdiastolic.delegate = self
        txtPulse.delegate = self
        txtReadingDate.delegate = self
        txtxVWComment.delegate = self
        txtxVWComment.text = "Comment"
        //txtxVWComment.textColor = UIColor.white
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        
        let recovedUserJsonData = UserDefaults.standard.object(forKey: "BpDict")
        
        if  recovedUserJsonData == nil{
            //apiCalling()
            return
        }
        
        let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
        if recovedUserJson == nil{
            // apiCalling()
            return
           
        }
        listArray = recovedUserJson! as! NSArray
        print(listArray)
        
       
        if putOrPost
        {
            if (dictDate.value(forKey: "bpId") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "bpId") as? Int)
                {
                    bpId = weight
                }
                else
                {
                    bpId = 0
                }
            }
            else{
                bpId = 0
            }
            
            if (dictDate.value(forKey: "systolic") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "systolic") as? Int)
                {
                    systolic = weight
                }
                else
                {
                    systolic = 0
                }
            }
            else{
                systolic = 0
            }
            
            if (dictDate.value(forKey: "diastolic") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "diastolic") as? Int)
                {
                    diastolic = weight
                }
                else
                {
                    diastolic = 0
                }
            }
            else{
                diastolic = 0
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
            
            if (dictDate.value(forKey: "pulse") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "pulse") as? Int)
                {
                    pulse = weight
                }
                else
                {
                    pulse = 0
                }
            }
            else{
                pulse = 0
            }
            
            if (dictDate.value(forKey: "personID") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "personID") as? Int)
                {
                    personID = weight
                }
                else
                {
                    personID = 0
                }
            }
            else{
                personID = 0
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
            if (dictDate.value(forKey: "source") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "source") as? String)
                {
                    source = weight
                }
                else
                {
                    source = ""
                }
            }
            else{
                source = ""
            }
            
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
                
        }
        else {
            
        }
       
        if putOrPost {
            self.txtSystolic.text = String (systolic)
            self.txtdiastolic.text = String (diastolic)
            self.txtPulse.text = String (pulse)
            
            if note == ""{
                self.txtxVWComment.text = "Comment"
            }
            else{
                self.txtxVWComment.text =  note
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
        else {
            self.txtSystolic.text = ""
            self.txtdiastolic.text = ""
            self.txtPulse.text = ""
            self.txtReadingDate.text = ""
            self.txtxVWComment.text =  "Comment"
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
// MARK: UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSystolic{
            self.txtSystolic.resignFirstResponder()
            return true
        }
        if textField == txtdiastolic{
            self.txtdiastolic.resignFirstResponder()
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
        
        if putOrPost {
            self.txtReadingDate.isUserInteractionEnabled = false
        }
        else {
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
            txtxVWComment.text = ""
        }
        else
        {
            
        }
      //  txtxVWComment.textColor = UIColor.white
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if txtxVWComment.text.isEmpty
        {
            txtxVWComment.text = "Comment"
          //  txtxVWComment.textColor = UIColor.white
            self.txtxVWComment.resignFirstResponder()
            
        }
        self.adjustTextViewHeight()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if txtxVWComment.text.isEmpty
        {
            txtxVWComment.text = "Comment"
           // txtxVWComment.textColor = UIColor.white
            self.txtxVWComment.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comment"
        {
            txtxVWComment.text = ""
        }
        else
        {
            
            
        }
       // txtxVWComment.textColor = UIColor.white
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtxVWComment.text.isEmpty
        {
            txtxVWComment.text = "Comment"
          //  txtxVWComment.textColor = UIColor.white
            self.txtxVWComment.resignFirstResponder()
        }
        
    }
    
    
    
    
    

    // // MARK:  Adjust TextView Height Method
    func adjustTextViewHeight() {
        let fixedWidth = self.txtxVWComment.frame.size.width
        let newSize = self.txtxVWComment.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
       
        if newSize.height < 100
        {
            self.txtVWHeight.constant = newSize.height
            self.view.layoutIfNeeded()
        }
        else
            
        {
            self.txtVWHeight.constant = self.txtxVWComment.contentSize.height
            self.txtVWHeight.constant = 100
            self.txtxVWComment.isScrollEnabled = true
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

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Post Blood Preasure Api

    func call_bloodPreasureApi()
    {
        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String

        let headers = [
            "x-auth-token": authToken,
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "9e6aacf6-dcef-6630-b810-938cf8d72026"
        ]
        var postData =  Data()

        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        source = UserDefaults.standard.value(forKey: "fullName") as! String

        let strDate = self.txtReadingDate.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"

        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)

        // convert to Integer
        let myInt = timeInterval
        let Systolic = Int(self.txtSystolic.text!)
        let Diastolic = Int(self.txtdiastolic.text!)
        let Pulse = Int(self.txtPulse.text!)
        var Note = String()
        
        if self.txtxVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtxVWComment.text!)
        }
        
        let parameters = [
            "deviceIP": "12.1.5",
            "systolic": Systolic as Any,
            "diastolic": Diastolic as Any,
            "pulse": Pulse as Any,
            "irregularities":"",
            "datenTime": myInt,
            "note": Note,
            "personID": personID,
            "enteredBy": 1,
            "visitdate": "",
            "source": source,
            "deviceId": ""

            ] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {

        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/bloodpressure")! as URL,
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
    
    // MARK: Put Blood Preasure Api

    func putBloodpressureApi()
    {
        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String

        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        source = UserDefaults.standard.value(forKey: "fullName") as! String

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
        let Systolic = Int(self.txtSystolic.text!)
        let Diastolic = Int(self.txtdiastolic.text!)
        let Pulse = Int(self.txtPulse.text!)
        
        var Note = String()
        
        if txtxVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtxVWComment.text!)
        }
        
        

        let parameters = [
            "bpId": bpId,
            "deviceIP": "12.1.5",
            "systolic": Systolic as Any,
            "diastolic": Diastolic as Any,
            "pulse": Pulse as Any,
            "irregularities": "",
            "datenTime": myInt,
            "note": Note,
            "personID": personID,
            "enteredBy": enteredBy,
            "source": source,
            "visitdate": "",
            "deviceId": ""
            ] as [String : Any]
        
        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            //try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/bloodpressure/\(bpId)")! as URL,
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
                                        "Blood Pressure data has been updated successfully", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.BloodList_update))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else{
                                    print("there is no data")
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
    
    
    func checkDelayTime(){
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
            if txtSystolic.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Systolic")
            }
            else if txtdiastolic.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Diastolic")
            }
            else if txtPulse.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Pulse")
            }
            else if txtReadingDate.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
            }
            else if((txtxVWComment.text == "Comment") || (txtxVWComment.text == "")){
                self.displayAlertMessage(messageToDisplay: "please enter Comment")
            }
            else
            {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                self.call_bloodPreasureApi()
            }
            
        }
        else{
            let alert = UIAlertController(title: "", message:
                "Please wait for \(delayTime) seconds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.bloodPressureBackAlert))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func bloodPressureBackAlert(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: BloodList Update UIAlertView Method

    func BloodList_update(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:  Save Button
    
    @IBAction func Save(_ sender: Any) {
        
        if putOrPost
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.putBloodpressureApi()
        }
        else
        {
            if !UserDefaults.standard.bool(forKey: "DelayBool"){
        if txtSystolic.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Systolic")
        }
        else if txtdiastolic.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Diastolic")
        }
        else if txtPulse.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Pulse")
        }
        else if txtReadingDate.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
        }
        else
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.call_bloodPreasureApi()
        }
               }else{
                checkDelayTime()
            }
     }
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

}
