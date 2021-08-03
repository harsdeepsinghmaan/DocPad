//
//  AdditionalWeightVC.swift
//  DocPad
//
//  Created by Deft Desk on 27/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import DropDown

class AdditionalWeightVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    var personID = Int()
    var source = String()
    var authToken = String()
    
    var weightId = Int()
    var weight1 = Int()
    var datenTime = NSNumber()
    var note = String()
    var enteredBy = Int()
    var putOrPost = Bool()
    var dictDate = NSDictionary()
    var heightOfText = CGRect()
    var hud  = MBProgressHUD()
    var url = String()
    var listArray  = NSArray()
    var dateString = String()
    var delayTime = String()
    var type = String()
    var display = String()
    
    let dropDown = DropDown()
    
    @IBOutlet weak var btnUnit: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtDateAndTime: UITextField!
    @IBOutlet weak var txtVWComment: UITextView!
    
    
    @IBOutlet weak var textVWHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        url = BaseUrl as! String
        txtWeight.delegate = self
        txtDateAndTime.delegate = self
        txtVWComment.delegate = self
        txtVWComment.text = "Comment"
      //  txtVWComment.textColor = UIColor.white
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        
        if putOrPost {
            if (dictDate.value(forKey: "weightID") as? Int) != nil{
                if  var weight = (dictDate.value(forKey: "weightID") as? Int){
                    weightId = weight
                }
                else{
                    weightId = 0
                }
            }
            else{
                weightId = 0
            }
             ///
            if (dictDate.value(forKey: "weight") as? Int) != nil{
                if  var weight = (dictDate.value(forKey: "weight") as? Int){
                    weight1 = weight
                }
                else{
                    weight1 = 0
                }
            }
            else{
                weight1 = 0
            }
             ///
            if (dictDate.value(forKey: "datenTime") as? NSNumber) != nil{
                if  var weight = (dictDate.value(forKey: "datenTime") as? NSNumber){
                    datenTime = weight
                }
                else{
                    datenTime = 0
                }
            }
            else{
                datenTime = 0
            }
                
            ///
            if (dictDate.value(forKey: "note") as? String) != "" {
                if  var weight = (dictDate.value(forKey: "note") as? String)                {
                    note = weight
                }
                else{
                    note = ""
                }
            }
            else{
                note = ""
            }
            if (dictDate.value(forKey: "unit") as? String) != "" {
                if  var unit = (dictDate.value(forKey: "unit") as? String)                {
                    self.btnUnit.setTitle(unit, for: .normal)
                }
                else{
                    
                }
            }
            else{
                
            }
            ///
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
            ////
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
            ////
            if (dictDate.value(forKey: "source") as? String) != "" {
                if  var weight = (dictDate.value(forKey: "source") as? String){
                    source = weight
                    
                }
                else{
                    source = ""
                }
            }
            else{
                source = ""
            }
         
        }
        else{
        }
        
       if putOrPost {
        self.txtWeight.text = String (weight1)
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
        
        self.txtDateAndTime.text = dateString

       }
        else{
            self.txtWeight.text = ""
            self.txtDateAndTime.text = ""
            self.txtVWComment.text = "Comment"
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
    
    @IBAction func UnitBtnClicked(_ sender: Any) {
        dropDown.direction = .bottom
        dropDown.bottomOffset = .init(x: 0, y: 35)
        dropDown.anchorView = (sender as! AnchorView)  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["lbs", "kg"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnUnit.setTitle(item, for: .normal)
            
            self.dropDown.hide()
            
        }
        dropDown.show()
    }
    

    // MARK: UITextField Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtWeight{
            self.txtWeight.resignFirstResponder()
            return true
        }
        if textField == txtDateAndTime{
            
            self.txtDateAndTime.resignFirstResponder()
            return true
        }

        else{
            return false
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if putOrPost {
            self.txtDateAndTime.isUserInteractionEnabled = false
        }
        else{
            if textField == txtDateAndTime{
                self.txtDateAndTime = textField
                
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
           // txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
            
        }
        self.adjustTextViewHeight()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if txtVWComment.text.isEmpty
        {
            txtVWComment.text = "Comment"
           // txtVWComment.textColor = UIColor.white
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
           // txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
        }
       
    }
    
    
    
    
    
    // // MARK:  Adjust TextView Height Method
    func adjustTextViewHeight() {
        let fixedWidth = self.txtVWComment.frame.size.width
        let newSize = self.txtVWComment.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height < 100
        {
            self.textVWHeight.constant = newSize.height
            self.view.layoutIfNeeded()
        }
        else
            
        {
            self.textVWHeight.constant = self.txtVWComment.contentSize.height
            self.textVWHeight.constant = 100
            self.txtVWComment.isScrollEnabled = true
        }
        
    }
    
    // MARK: UIDatePicker method
@objc func updateDateField(sender: UIDatePicker) {
    txtDateAndTime.text = formatDateForDisplay(date: sender.date)
}

// Formats the date chosen with the date picker.

fileprivate func formatDateForDisplay(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
    return formatter.string(from: date)
}

    // MARK: POST Weight Api
    
    func callWeightRecordApi()

    {
        hud.show(animated: true)
        
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()

        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        source = UserDefaults.standard.value(forKey: "fullName") as! String

        //        let str = String(format:"%d",_WeightId)

        let strDate = self.txtDateAndTime.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"

        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)

        // convert to Integer
        let myInt = timeInterval

        let Weight = Int(self.txtWeight.text!)
        var Note = String()
        
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }
        
        
        let parameters = [
            "weight": Weight as Any,
            "datenTime": myInt,
            "note": Note,
            "personID": personID,
            "enteredBy": 1,
            "visitdate": "",
            "source": source,
            "deviceId": "",
            "unit": self.btnUnit.title(for: .normal)

            ] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {

        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/weight")! as URL,
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
                              //  print(dict)

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
    
    // MARK: PUT Weight Api

    func putWeightApi()
    {
    hud.show(animated: true)
        
    authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String

    let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
    var postData =  Data()
        
//    let strDate = self.txtDateAndTime.text
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
//
//    let someDate = dateFormatter.date(from: strDate!)
//    let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)

    // convert to Integer
//    let myInt = Int(timeInterval)
        
    let myInt = datenTime
        
    let Weight = Int(self.txtWeight.text!)
        var Note = String()
        
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }
        
    

    let parameters = [
    "weightID": weightId,
    "weight": Weight as Any,
    "datenTime": myInt,
    "note": Note,
    "personID": personID,
    "enteredBy": enteredBy,
    "deviceIP": "12.23",
    "deviceId": "",
    "source":source,
    "unit": self.btnUnit.title(for: .normal)
    ] as [String : Any]
    
    
    do {
    postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
    
    
    //try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
    }
    catch {
    
    }
    let request = NSMutableURLRequest(url: NSURL(string: "\(url)/weight/\(weightId)")! as URL,
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
  //  print(dict)
        
    if dict != nil {
        let alert = UIAlertController(title: "Successs", message:
            "Weight data has been updated successfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.WeightList_pdate))
        
        self.present(alert, animated: true, completion: nil)
    }
    else {
    print("there is no data")
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
            if txtWeight.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter the Weight")
            }
            else if txtDateAndTime.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
            }
            else if ((txtVWComment.text == "Comment") || (txtVWComment.text == "")){
                self.displayAlertMessage(messageToDisplay: "please enter Comment")
            }
            else
            {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                self.callWeightRecordApi()
            }
            
        }
        else{
            let alert = UIAlertController(title: "", message:
                "Please wait for \(delayTime) seconds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.weightBackAlert))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func weightBackAlert(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: WeightList Update Method

    func WeightList_pdate(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: Back Button

    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK:  Save Button

    @IBAction func Save(_ sender: Any) {
        
        if putOrPost
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.putWeightApi()
        }
        else
        {
            if !UserDefaults.standard.bool(forKey: "DelayBool"){
                if txtWeight.text == ""{
                    self.displayAlertMessage(messageToDisplay: "please enter the Weight")
                }
                else if txtDateAndTime.text == ""{
                    self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
                }
                else
                {
                    hud = MBProgressHUD.showAdded(to: view, animated: true)
                    self.callWeightRecordApi()
                }
                
            }
            else{
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
