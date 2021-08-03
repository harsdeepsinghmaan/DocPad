//
//  AdditionalGlucoseVC.swift
//  DocPad
//
//  Created by Deft Desk on 28/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import DropDown

class AdditionalGlucoseVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    var hud  = MBProgressHUD()
    var putOrPost = Bool()
    var dictDate = NSDictionary()
    var authToken = String()
    var glucoseTestID = Int()
    var measurement = Int()
    var datenTime = NSNumber()
    var measurementContext = String()
    var measurementType = String()
    var note = String()
    var personID = Int()

    var personIDPut = Int()
    var enteredByPut = Int()
    var sourcePut = String()

    var enteredBy = Int()
    var source = String()
    var url = String()
    var listArray  = NSArray()
    var dateString = String()
    var delayTime = String()
    
    
    
    
    var  dateFormatter = DateFormatter()
    
    let dropDownContext = DropDown()
    let dropDownType = DropDown()
    
    @IBOutlet weak var btnMeasurementContext: UIButton!
    @IBOutlet weak var btnMeasurementType: UIButton!
    @IBOutlet weak var txtMeasurement: UITextField!
    @IBOutlet weak var txtReadingDate: UITextField!
    @IBOutlet weak var txtVWComment: UITextView!
    @IBOutlet weak var txtVWHeight: NSLayoutConstraint!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        
        url = BaseUrl as! String
        txtMeasurement.delegate = self
        txtReadingDate.delegate = self
        txtVWComment.delegate = self
        txtVWComment.text = "Comment"
        //txtVWComment.textColor = UIColor.white
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        

        
        // chack didselect or add
        if putOrPost
        {
            if (dictDate.value(forKey: "glucoseTestID") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "glucoseTestID") as? Int)
                {
                    glucoseTestID = weight
                }
                else
                {
                    glucoseTestID = 0
                }
            }
            else{
                glucoseTestID = 0
            }
            
            if (dictDate.value(forKey: "measurement") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "measurement") as? Int)
                {
                    measurement = weight
                }
                else
                {
                    measurement = 0
                }
            }
            else{
                measurement = 0
            }
            
            if (dictDate.value(forKey: "measurementContext") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "measurementContext") as? String)
                {
                    measurementContext = weight
                }
                else
                {
                    measurementContext = ""
                }
            }
            else{
                measurementContext = ""
            }
            
            if (dictDate.value(forKey: "measurementType") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "measurementType") as? String)
                {
                    measurementType = weight
                }
                else
                {
                    measurementType = ""
                }
            }
            else{
                measurementType = ""
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
            
            ///
            if (dictDate.value(forKey: "personID") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "personID") as? Int)
                {
                    personIDPut = weight
                }
                else
                {
                    personIDPut = 0
                }
            }
            else{
                personIDPut = 0
            }
            ////
            if (dictDate.value(forKey: "enteredBy") as? Int) != nil{
                
                if  var weight = (dictDate.value(forKey: "enteredBy") as? Int)
                {
                    enteredByPut = weight
                }
                else
                {
                    enteredByPut = 0
                }
            }
            else{
                enteredByPut = 0
            }
            
            if (dictDate.value(forKey: "source") as? String) != "" {
                
                if  var weight = (dictDate.value(forKey: "source") as? String)
                {
                    sourcePut = weight
                }
                else
                {
                    sourcePut = ""
                }
            }
            else{
                sourcePut = ""
            }
        }
        else
        {
            
        }
        
        
        if putOrPost
        {
            self.txtMeasurement.text = String (measurement)
            self.btnMeasurementContext.setTitle(String(measurementContext), for: .normal)
            self.btnMeasurementType.setTitle(String(measurementType), for: .normal)
            
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
            self.txtMeasurement.text = ""
            self.btnMeasurementContext.setTitle("", for: .normal)
            self.btnMeasurementType.setTitle("", for: .normal)
            self.txtReadingDate.text = ""
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
    // MARK: UITextField Method

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMeasurement{
            self.txtMeasurement.resignFirstResponder()
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
        else{
            if textField == txtReadingDate {
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
           // txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
            
        }
        self.adjustTextViewHeight()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if txtVWComment.text.isEmpty
        {
            txtVWComment.text = "Comment"
         //   txtVWComment.textColor = UIColor.white
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
          //  txtVWComment.textColor = UIColor.white
            self.txtVWComment.resignFirstResponder()
        }
        
    }
    
    // // MARK:  Adjust TextView Height Method
    func adjustTextViewHeight() {
        let fixedWidth = self.txtVWComment.frame.size.width
        let newSize = self.txtVWComment.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        
        if newSize.height < 100
        {
            self.txtVWHeight.constant = newSize.height
            self.view.layoutIfNeeded()
        }
        else
            
        {
            self.txtVWHeight.constant = self.txtVWComment.contentSize.height
            self.txtVWHeight.constant = 100
            self.txtVWComment.isScrollEnabled = true
        }
        
    }
    
    
    // MARK: UIDatePicker Method

    @objc func updateDateField(sender: UIDatePicker) {
        txtReadingDate.text = formatDateForDisplay(date: sender.date)
    }
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
        return formatter.string(from: date)
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
    
    @IBAction func measurementContext(_ sender: UIButton) {
        dropDownContext.direction = .bottom
        dropDownContext.bottomOffset = .init(x: 0, y: 35)
        dropDownContext.anchorView = (sender as AnchorView)  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDownContext.dataSource = ["Before Lunch", "After Lunch","Before Dinner","After Dinner"]
        // Action triggered on selection
        dropDownContext.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnMeasurementContext.setTitle(item, for: .normal)
            self.dropDownContext.hide()
        }
        dropDownContext.show()
    }
    
    @IBAction func measurementType(_ sender: UIButton) {
        dropDownType.direction = .bottom
        dropDownType.bottomOffset = .init(x: 0, y: 35)
        dropDownType.anchorView = (sender as AnchorView)  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDownType.dataSource = ["Normal","Plasma"]
        // Action triggered on selection
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnMeasurementType.setTitle(item, for: .normal)
            self.dropDownType.hide()
            
        }
        dropDownType.show()
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
            self.putGlucoseApi()
        }
        else
        {
             if !UserDefaults.standard.bool(forKey: "DelayBool"){
        if txtMeasurement.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Measurement")
        }
        else if btnMeasurementContext.title(for: .normal) == ""{
            self.displayAlertMessage(messageToDisplay: "please enter the Measurement Context")
        }
        else if btnMeasurementType.title(for: .normal) == ""{
            self.displayAlertMessage(messageToDisplay: "please enter the Measurement Type")
        }
        else if txtReadingDate.text == ""{
            self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
        }
        else
        {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.callGlucoseRecordApi()
        }
             }else{
                checkDelayTime()
            }
    }
            
            
    }
    
    // MARK: POST Glucose Api
    func callGlucoseRecordApi()
    {
        hud.show(animated: true)
        
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
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
        let Measurement = Int(self.txtMeasurement.text!)
        let MeasurementContext = String(btnMeasurementContext.title(for: .normal)!)
        let MeasurementType = String(btnMeasurementType.title(for: .normal)!)
        var Note = String()
        
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }
        
        
        let parameters = [
            "deviceIP": "12.5",
            "measurement": Measurement as Any,
            "measurementContext": MeasurementContext as Any,
            "measurementType": MeasurementType as Any,
            "datenTime": myInt,
            "comparision": "",
            "controlTest": "",
            "outsideTemperatureRange": "",
            "note": Note,
            "personID": personID,
            "enteredBy": 1,
            "source": source,
            "visitId": 1,
            "deviceId": ""  // imp
            
            ] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/glucose")! as URL,
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
    
    // MARK: PUT Glucose Api

    func putGlucoseApi()
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
//       // let timeInterval = someDate?.timeIntervalSince1970
//        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
//        // convert to Integer
//        let myInt = Int(timeInterval)
        
        let myInt = datenTime
        
        let Measurement = Int(self.txtMeasurement.text!)
        let MeasurementContext = String(btnMeasurementContext.title(for: .normal)!)
        let MeasurementType = String(btnMeasurementType.title(for: .normal)!)
        
        var Note = String()
        
        if txtVWComment.text == "Comment" {
            Note = ""
        }
        else{
            Note = String(self.txtVWComment.text!)
        }
        
        
        let parameters = [
           // "glucoseTestID": glucoseTestID,
            "deviceIP": "12.5",
            "measurement": Measurement as Any,
            "measurementContext": MeasurementContext as Any,
            "measurementType": MeasurementType as Any,
            "datenTime": myInt,
            "comparision": "",
            "controlTest": "",
            "outsideTemperatureRange": "",
            "note": Note,
            "personID": personIDPut,
            "enteredBy": enteredByPut,
            "source": sourcePut,
            "visitId": 1,
            "deviceId": ""  // imp

            ] as [String : Any]
        
        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            
            //try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/glucose/\(glucoseTestID)")! as URL,
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
                                        "Glucose data has been updated successfully", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.GlucoseList_update))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else{
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
            if txtMeasurement.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Measurement")
            }
            else if (btnMeasurementContext.title(for: .normal)!) == ""{
                self.displayAlertMessage(messageToDisplay: "please enter the Measurement Context")
            }
            else if (btnMeasurementType.title(for: .normal)!) == ""{
                self.displayAlertMessage(messageToDisplay: "please enter the Measurement Type")
            }
            else if txtReadingDate.text == ""{
                self.displayAlertMessage(messageToDisplay: "please enter Date and Time")
            }
                
            else if ((txtVWComment.text == "Comment") || (txtVWComment.text == "")){
                self.displayAlertMessage(messageToDisplay: "please enter Comment")
            }
            else
            {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                self.callGlucoseRecordApi()
            }
            
        }
        else{
            let alert = UIAlertController(title: "", message:
                "Please wait for \(delayTime) seconds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.glucoseBackAlert))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func glucoseBackAlert(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    // MARK: GlucoseList Update Method
    func GlucoseList_update(action: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
