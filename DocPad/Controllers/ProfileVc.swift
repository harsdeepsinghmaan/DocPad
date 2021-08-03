//
//  ProfileVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 04/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import SDWebImage
import MBProgressHUD
import DropDown
class ProfileVc: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    //@IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtPersonType: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
   // @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtName: UITextField!
  //  @IBOutlet weak var txtContactAddress: UITextField!
    @IBOutlet weak var txtMobileNumber1: UITextField!
   // @IBOutlet weak var txtMobileNumber2: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var btnGenderOutlet: UIButton!
    
    
    var selectedImage = UIImage()
    var dict = NSMutableDictionary()
    var personDict = NSDictionary()
    var hud  = MBProgressHUD()
    var authToken = String()
    let dropDown = DropDown()
    var firstName = String()
    var middleName = String()
    var lastName = String()
    var dob = String()
    var persontype = [String: Any]()
    var type = String()
    var mobile = String()
    var email = String()
    var addressLine1 = String()
    var addressline2 = String()
    var state = String()
    var emergencyContactName = String()
    var emrAddress = String()
    var emrMobileNumber = String()
    var emrPhoneNumber = String()
    var imageurl = String()
    var gender = String()
    var zip = NSNumber()
    var fullName = String()
    var personID = Int()
    var mobileInt = Int()
    var image = UIImage()
    var changedProfileUrl = String()
    var imagePicker = UIImagePickerController()
    var checkImageFromPicker = Bool()
    var viewHasMovedToRight = Bool()
    var url = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = BaseUrl as! String
        txtFirstName.delegate = self
      //  txtMiddleName.delegate = self
        txtLastName.delegate = self
        txtDob.delegate = self
        txtPersonType.delegate = self
        txtMobile.delegate = self
        txtEmailAddress.delegate = self
        txtAddress.delegate = self
       // txtState.delegate = self
        txtName.delegate = self
       // txtContactAddress.delegate = self
        txtMobileNumber1.delegate = self
       // txtMobileNumber2.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtZipCode.delegate = self
        imagePicker.delegate = self
        checkImageFromPicker = false
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
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        let recovedUserJsonData = UserDefaults.standard.object(forKey: "LoginDict")
        
        if  recovedUserJsonData == nil{
            //apiCalling()
            return
        }
        
        let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
        if recovedUserJson == nil{
            // apiCalling()
            return
        }
        
        
        dict = NSMutableDictionary(dictionary: recovedUserJson as! [AnyHashable : Any], copyItems: true)
        print(dict)
        self.personDict = dict
        getData()
        //        DispatchQueue.main.async{
        //            self.getData()
        //        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if  checkImageFromPicker == true{
            
        }
        else{
            getData()
        }
        
    }
    
    
    // MARK: - Get Data
    
    func getData(){
        
        print(personDict)
        if let firstname = personDict.value(forKey: "firstName") as? String{
            firstName = firstname
        }
        else{
            firstName = ""
        }
        if let middlename = personDict.value(forKey: "middleName") as? String{
            middleName = middlename
        }
        else{
            middleName = ""
        }
        if let lastname = personDict.value(forKey: "lastName") as? String{
            lastName = lastname
        }
        else{
            lastName = ""
        }
        if let doB = personDict.value(forKey: "dob") as? String{
            dob = doB
        }
        else if let doB = personDict.value(forKey: "dob") as? Int{
            let timeStamp = doB
            let timeDouble = Double(timeStamp)
            
            let unixTimeStamp: Double = timeDouble / 1000.0
            let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: exactDate)
            
            dob = dateString
        }
        else{
            dob = ""
        }
        
        
        if let Mobile = personDict.value(forKey: "mobile") as? String{
            mobile = Mobile
        }
        else{
            mobile = ""
        }
        if let Email = personDict.value(forKey: "email") as? String{
            email = Email
        }
        else{
            email = ""
        }
        if let addressline1 = personDict.value(forKey: "addressLine1") as? String{
            addressLine1 = addressline1
            
        }
        else{
            addressLine1 = ""
        }
        if let addressLine2 = personDict.value(forKey: "addressLine2") as? String{
            addressline2 = addressLine2
            
        }
        else{
            addressline2 = ""
        }
        if let State = personDict.value(forKey: "state") as? String{
            state = State
            
        }
        else{
            state = ""
        }
        if let emergencyContactname = personDict.value(forKey: "emergencyContactName") as? String{
            emergencyContactName = emergencyContactname
            
        }
        else{
            emergencyContactName = ""
        }
        if let EmrAddress = personDict.value(forKey: "emrAddress") as? String{
            emrAddress = EmrAddress
            
        }
        else{
            emrAddress = ""
        }
        if let EmrMobileNumber = personDict.value(forKey: "emrMobileNumber") as? String{
            emrMobileNumber = EmrMobileNumber
            
        }
        else{
            emrMobileNumber = ""
        }
        
        if let EmrPhoneNumber = personDict.value(forKey: "emrPhoneNumber") as? String{
            emrPhoneNumber = EmrPhoneNumber
            
        }
        else{
            emrPhoneNumber = ""
        }
        if let Imageurl = personDict.value(forKey: "imageurl") as? String{
            
            imageurl = Imageurl
            
        }
        else{
            imageurl = ""
        }
        if let Gender = personDict.value(forKey: "gender") as? String{
            gender = Gender
            
        }
        else{
            gender = ""
        }
        if let Zip = personDict.value(forKey: "zip") as? NSNumber{
            zip = Zip
            
        }
        else{
            zip = 0
        }
        
        if let PersonID = personDict.value(forKey: "personID") as? Int{
            personID = PersonID
            
        }
        else{
            personID = 0
        }
        
        if let personType = personDict.value(forKey: "persontype") as? [String: Any]{
            persontype = personType
            type = persontype["type"] as! String
        }
        else{
            type = ""
        }
        
        fullName = firstName + middleName + lastName
        
        txtFirstName.text = firstName
       // txtMiddleName.text = middleName
        txtLastName.text = lastName
        txtDob.text = dob
        txtPersonType.text = type
        txtMobile.text = mobile
        txtEmailAddress.text = email
        txtAddress.text = addressLine1 + addressline2
       // txtState.text = state
        txtName.text = emergencyContactName
       // txtContactAddress.text = emrAddress
        txtMobileNumber1.text = String(emrMobileNumber)
       // txtMobileNumber2.text = String(emrPhoneNumber)
        btnGenderOutlet.setTitle(gender, for: .normal)
        self.btnGenderOutlet.setTitleColor(UIColor.white, for: .normal)
        txtZipCode.text = String(format:"%@",zip)
        
        if imageurl != ""{
            
            self.profileImgVw.sd_setImage(with: URL(string: imageurl), placeholderImage: nil)
        }
        else{
            
        }
        
        
    }
    
    // MARK: - Change Password Api
    
    func putChangePasswordApi(_personID: Int , _changePassword: String){
        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": self.authToken]
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/users/\(_personID)?password=\(_changePassword)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "PUT"
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
                                    
                                    
                                    self.callUpdateApi(_firstName: self.firstName, _lastName: self.lastName, _fullName: self.fullName, _gender: self.gender, _dob: self.dob, _addressLine1: self.addressLine1, _zip: self.zip, _mobile: self.mobileInt, _email: self.email, _imageurl: self.imageurl, _personID:self.personID, _emrName: self.txtName.text!, _emrMobile1: self.txtMobileNumber1.text!)
                                    
                                    
                                    
                                    
                                }
                                else{
                                    self.displayAlertMessage(messageToDisplay: "Please try after some time")
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
    
    // MARK: - Profile Update Api
    
    func callUpdateApi(_firstName: String,_lastName: String,_fullName: String,_gender: String,_dob: String,_addressLine1: String,_zip: NSNumber,_mobile: Int,_email: String,_imageurl: String , _personID: Int, _emrName: String, _emrMobile1: String){
        hud.show(animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": self.authToken,"content-type": "application/json"]
        var postData =  Data()
        
        var parameters = [String: Any]()
        if _firstName != "" {
            parameters["firstName"] = _firstName
        }
        if _lastName != "" {
            parameters["lastName"] = _lastName
        }
        if _fullName != "" {
            parameters["fullName"] = _fullName
        }
        if _dob != "" {
            parameters["dob"] = _dob
        }
        if _addressLine1 != "" {
            parameters["addressLine1"] = _addressLine1
        }
        if _zip != 0 {
            parameters["zip"] = _zip
        }
        
        parameters["personID"] = _personID
        
        if _mobile != 0 {
            parameters["mobile"] = _mobile
        }
        if _imageurl != "" {
            parameters["imageurl"] = _imageurl
        }
        if _gender != "" {
            parameters["gender"] = _gender
        }
        if _email != "" {
            parameters["email"] = _email
        }
        if _emrName != "" {
            parameters["emergencyContactName"] = _emrName
        }
        if _emrMobile1 != "" {
            parameters["emrMobileNumber"] = _emrMobile1
        }

        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/person/\(_personID)")! as URL,
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
                                
                                if dict != nil{
                                    do{
                                        var jsonData = Data()
                                        if #available(iOS 11.0, *) {
                                            jsonData = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
                                        } else {
                                            // Fallback on earlier versions
                                            jsonData =  NSKeyedArchiver.archivedData(withRootObject: dict)
                                        }
                                        UserDefaults.standard.set(jsonData, forKey: "LoginDict")
                                        var imgUrl = dict.value(forKey: "imageurl") as? String
                                        if imgUrl == nil {
                                            imgUrl = ""
                                        }
                                        UserDefaults.standard.set(imgUrl, forKey: "ImageUrl")
                                        UserDefaults.standard.set(dict.value(forKey: "fullName"), forKey: "fullName")
                                        UserDefaults.standard.set(dict.value(forKey: "email"), forKey: "email")
                                        UserDefaults.standard.synchronize()
                                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                                        let alert = UIAlertController.init(title: "", message:"Update profile successfully!", preferredStyle: .alert)
                                        let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                                        alert.addAction(ok)
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    catch{
                                        print("error")
                                    }
                                }else {
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Button Action
    
    @IBAction func chooseProfileImg(_ sender: Any) {
        
        self.chooseImageFromGalleryAndCamera()
    }
    
    // MARK: - Profile Image Update Api
    
    func webServicePostFileRequest(Image: UIImage){
        
        if self.isReachable() {
            
            hud.show(animated: true)
            authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
            let headers: [String:Any] = ["X-Auth-Token": self.authToken]
            
            let imageData = Image.jpegData(compressionQuality: 0.4)
            
            let fullUrlString = "\(url)/person/uploadfile/\(personID)"
            
            let url1 = URL(string: fullUrlString)
            var request = URLRequest(url: url1!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = (headers as! [String : String])
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // request.setValue("multipart/form-data;g1hsttjkq6ga1tcchin0acn9vn; boundary=\(boundary)", forHTTPHeaderField: "X-Auth-Token")
            
            //        let parameters = [
            //            "personID" : personID
            //            ] as [String : Any]
            let randomInt = Int.random(in: 10...10000)
            //
            let fileName = String(format:"image%d.jpg",randomInt)
            
            let mimeType:String = "image/jpg"
            
            //        var mimeType:String = "text/plain"
            
            
            request.httpBody = createBody(boundary: boundary,
                                          data: imageData!,
                                          mimeType: mimeType,
                                          filename: fileName)
            
            let urlSessionConfiguration = URLSessionConfiguration.default
            let urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
            let urlSessionData = urlSession.dataTask(with: request) { (data, response, error) in
                
                if (error != nil) {
                    DispatchQueue.main.async {
                        self.hud.hide(animated: true)
                    }
                } else {
                    
                    if(response != nil && data != nil ) {
                        
                        do{
                            
                            if let json = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                                print("\(String(describing: json))")
                                
                                self.hud.hide(animated: true)
                                self.changedProfileUrl = json as String
                                UserDefaults.standard.set(self.changedProfileUrl, forKey: "ImageUrl")
                                UserDefaults.standard.synchronize()
                                self.dict.setValue(self.changedProfileUrl, forKey: "imageurl")
                                if self.changedProfileUrl != ""{
                                    do{
                                        var jsonData = Data()
                                        if #available(iOS 11.0, *) {
                                            jsonData = try NSKeyedArchiver.archivedData(withRootObject: self.dict, requiringSecureCoding: true)
                                        } else {
                                            // Fallback on earlier versions
                                            jsonData =  NSKeyedArchiver.archivedData(withRootObject: self.dict)
                                        }
                                        UserDefaults.standard.set(jsonData, forKey: "LoginDict")
                                        UserDefaults.standard.synchronize()
                                        DispatchQueue.main.async {
                                            self.getData()
                                        }
                                        
                                    }
                                        
                                    catch{
                                        self.hud.hide(animated: true)
                                        print("error")
                                    }
                                    
                                }else{
                                    self.hud.hide(animated: true)
                                    print("error")
                                }
                                
                                
                            }else{
                                self.hud.hide(animated: true)
                                print("no json data")
                            }
                        }catch let error{
                            self.hud.hide(animated: true)
                            print("no json data")
                        }
                    }else{
                        self.hud.hide(animated: true)
                        print("no json data")
                    }
                }
            }
            urlSessionData.resume()
            
        }
            
        else{
            displayAlertMessage(messageToDisplay: "Please check your internet connection")
        }
    }
    
    
    func createBody(boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        var body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        //        for (key, value) in parameters {
        //            body.appendString(boundaryPrefix)
        //            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        //            body.appendString("\(value)\r\n")
        //        }
        
        body.appendString(string: boundaryPrefix)
        body.appendString(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString(string: "\r\n")
        //  body.appendString(string: "--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName{
            self.txtFirstName.resignFirstResponder()
            return true
        }
        else if textField == txtLastName{
            self.txtLastName.resignFirstResponder()
            return true
        }
        else if textField == txtDob{
            self.txtDob.resignFirstResponder()
            return true
        }
        else if textField == txtPersonType{
            self.txtPersonType.resignFirstResponder()
            return true
        }
        else if textField == txtMobile{
            self.txtMobile.resignFirstResponder()
            return true
        }
        else if textField == txtEmailAddress{
            self.txtEmailAddress.resignFirstResponder()
            return true
        }
        else if textField == txtAddress{
            self.txtAddress.resignFirstResponder()
            return true
        }
        else if textField == txtName{
            self.txtName.resignFirstResponder()
            return true
        }
        else if textField == txtMobileNumber1{
            self.txtMobileNumber1.resignFirstResponder()
            return true
        }
        else if textField == txtPassword{
            self.txtPassword.resignFirstResponder()
            return true
        }
        else if textField == txtConfirmPassword{
            self.txtConfirmPassword.resignFirstResponder()
            return true
        }
        else if textField == txtZipCode{
            self.txtZipCode.resignFirstResponder()
            return true
        }
        else{
            return false
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDob{
            self.txtDob = textField
            
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
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        //        if textField == txtMobile {
        //            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
        //            let characterSet = CharacterSet(charactersIn: string)
        //            return allowedCharacters.isSuperset(of: characterSet)
        //        }
        if textField == txtMobile {
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 10
        }
        
        if textField == txtZipCode {
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 6
        }
        return true
    }
    @objc func updateDateField(sender: UIDatePicker) {
        txtDob.text = formatDateForDisplay(date: sender.date)
    }
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    
    // MARK: - Button Action
    
    @IBAction func btnUploadImage(_ sender: Any) {
        if image.size.width == 0{
            displayAlertMessage(messageToDisplay: "please select image first")
        }else{
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            webServicePostFileRequest(Image: image)
        }
        
    }
    
    @objc func chooseImageFromGalleryAndCamera()
    {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.handelUploadCamera()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.handelUploadTap()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        firstName = txtFirstName.text!
        lastName = txtLastName.text!
        fullName = String(format:"%@ %@ %@", firstName, middleName, lastName)
        dob = txtDob.text!
        addressLine1 = txtAddress.text!
        zip = NSNumber.init(value:Int(txtZipCode.text!)!)
        mobile = txtMobile.text!
        if mobile != nil{
            mobileInt = Int(txtMobile.text!) ?? 0
        }
        email = txtEmailAddress.text!
        
        if ((txtPassword.text != "" && txtConfirmPassword.text == "") || (txtPassword.text == "" && txtConfirmPassword.text != "")){
            self.displayAlertMessage(messageToDisplay: "Please enter the password")
        }
        else if (txtPassword.text != txtConfirmPassword.text) {
            self.displayAlertMessage(messageToDisplay: "Please check the password")
        }
        else if ((txtPassword.text != "" && txtConfirmPassword.text != "") && (txtPassword.text == txtConfirmPassword.text)){
            if validate(password: txtPassword.text!) == true{
                let changePassword = txtPassword.text
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                putChangePasswordApi(_personID: personID, _changePassword: changePassword!)
            }
            else {
                self.displayAlertMessage(messageToDisplay: "Password should contain one uppercase letter, lowercase letter and digit or specal character")
            }
        }
        else {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.callUpdateApi(_firstName: self.firstName, _lastName: self.lastName, _fullName: self.fullName, _gender: self.gender, _dob: self.dob, _addressLine1: self.addressLine1, _zip: self.zip, _mobile: self.mobileInt, _email: self.email, _imageurl: self.imageurl, _personID:self.personID, _emrName: self.txtName.text!, _emrMobile1: self.txtMobileNumber1.text!)
        }
        
    }
    
    
    @IBAction func btnGenderDropdown(_ sender: Any) {
        //        dropDown.direction = .bottom
        //        dropDown.bottomOffset = .init(x: 0, y: 35)
        dropDown.anchorView = btnGenderOutlet  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Male","Female"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.gender = item
            self.btnGenderOutlet.setTitle(item, for: .normal)
            self.btnGenderOutlet.setTitleColor(UIColor.white, for: .normal)
            
            
            self.dropDown.hide()
            
        }
        dropDown.show()
        
        
    }
    
    
    @objc func handelUploadTap() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                        
                        
                        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                        self.imagePicker.allowsEditing = true
                        
                        self.imagePicker.mediaTypes = [kUTTypeImage as String]
                        self.present(self.imagePicker, animated: true, completion: nil)
                        
                    }
                }
                
            })
        }
        else if photos == .authorized {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                
                
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true
                
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: nil)
                
            }
        }
    }
    
    @objc func handelUploadCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Image Picker Delegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        //        image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!
        if let editedImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            image = editedImage
            self.profileImgVw.image = editedImage
            checkImageFromPicker = true
            selectedImage =  editedImage
        }
        else if let origionalImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            image = origionalImage
            self.profileImgVw.image = origionalImage
            selectedImage =  origionalImage
            checkImageFromPicker = true
        }
        //        if profileImgVw.image != nil{
        //          profileImgVw.image = image
        //        }
        //        else{
        //            profileImgVw.image = image
        //        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    private func handelSelectedImageForInfo(info: [String: AnyObject]) {
        // var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            self.profileImgVw.image = editedImage
            selectedImage =  editedImage
        }
        else if let origionalImage = info["UIImagePickerControllerOrigionalImage"] as? UIImage {
            self.profileImgVw.image = origionalImage
            selectedImage =  origionalImage
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
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

// MARK: - Extension

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


