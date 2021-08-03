//
//  GlucoseVC.swift
//  DocPad
//
//  Created by Virender Deftdesk on 02/05/19.
//  Copyright © 2019 deftdesk. All rights reserved.
//

import UIKit
import MBProgressHUD

class GlucoseVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var height = CGFloat ()
    var models: [String] = []
    var listArray = NSArray()
    var dataDict = NSDictionary()
    
    var authToken = String()
    var hud  = MBProgressHUD()
    var dataArray = NSMutableArray()
    var fromIndex = Int()
    var pageSize = Int()
    var isPageRefresing = Bool()
    var personID = Int()
    
    var weightId = Int()
    var weight = Double()
    
    var datenTime = NSNumber()
    var note = String()
    
    var enteredBy = Int()
    var source = String()
    var intSection = Int()
    
    var arrayLevel_All_Data = [[String:Any]]()
    var newDataArray = Array<Any>()
    var stringdatentime = String()
    var url = String()
    
    
    
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = BaseUrl as! String
        self.tableVW.separatorStyle = .none
        tableVW.delegate = self
        tableVW.dataSource = self
        tableVW.estimatedRowHeight = 200.0
        
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        
        models = (0...100).map { _ in randomInt(min: 2, max: 5) }.map(Lorem.sentences)
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        fromIndex = 1
        pageSize = 30
        isPageRefresing = false
        self.dataArray.removeAllObjects()
        getGlucoseApi(getData: 1)
        
        
    }
    
    
    // MARK: - Text View Delegate Method
    
    func textViewDidChange(textView: UITextView) {
        
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height //iOS 8+ only
        
        if startHeight != calcHeight {
            
            UIView.setAnimationsEnabled(false) // Disable animations
            self.tableVW.beginUpdates()
            self.tableVW.endUpdates()
            
            let scrollTo = self.tableVW.contentSize.height - self.tableVW.frame.size.height
            self.tableVW.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: false)
            
            UIView.setAnimationsEnabled(true) // Re-enable animations.
        }
    }
    
    
    
    
    // MARK: - Get Api
    
    func getGlucoseApi(getData: Int){
        hud.show(animated: true)
        let headers: [String:Any] = ["X-Auth-Token": self.authToken]
        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/glucose/pagination/\(personID)?currentPage=\(getData)&pageSize=30&sortFields=datenTime&sortDirections=desc")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "GET"
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
                                    self.listArray = dict.value(forKey: "list") as! NSArray
                                    for i in 0..<self.listArray.count{
                                        dict = self.listArray.object(at: i) as! NSDictionary
                                        self.dataArray.add(dict)
                                    }
                                    if self.listArray.count < 30{
                                        self.isPageRefresing = true
                                        
                                    }
                                    else{
                                        self.isPageRefresing = false
                                    }
                                    print(self.dataArray.count)
                                    
                                    self.newDataArray = self.dataArray.sorted(by: { (Obj1, Obj2) -> Bool in
                                        
                                        var time1 = String()
                                        var time2 = String()
                                        
                                        var timeInt = Int()
                                        var timeInt2 = Int()
                                        
                                        
                                        if (Obj1 as AnyObject).value(forKey: "datenTime") as? Int != nil{
                                            timeInt = ((Obj1 as AnyObject).value(forKey: "datenTime") as? Int)!
                                            
                                        }
                                        
                                        if (Obj2 as AnyObject).value(forKey: "datenTime") as? Int != nil{
                                            timeInt2 = ((Obj2 as AnyObject).value(forKey: "datenTime") as? Int)!
                                        }
                                        
                                        time1 = String(timeInt)
                                        
                                        time2 = String(timeInt2)
                                        
                                        return  self.stringToSeconds(time1) > self.stringToSeconds(time2)
                                    })
                                    
                                    print(self.newDataArray)
                                    if self.newDataArray.count != 0{
                                        do{
                                            var jsonData = Data()
                                            if #available(iOS 11.0, *) {
                                                jsonData = try NSKeyedArchiver.archivedData(withRootObject: self.newDataArray, requiringSecureCoding: true)
                                            } else {
                                                // Fallback on earlier versions
                                                jsonData =  NSKeyedArchiver.archivedData(withRootObject: self.newDataArray)
                                            }
                                            UserDefaults.standard.set(jsonData, forKey: "GlucoseDict")
                                            UserDefaults.standard.synchronize()
                                            
                                        }
                                        catch{
                                            print("error")
                                        }
                                        
                                        
                                        
                                    }
                                    else{
                                        
                                    }
                                    self.arrayLevel_All_Data.removeAll()
                                    var arrayLevel2 = [[String:Any]]()
                                    var arrayLevel1 = [[String:Any]]()
                                    
                                    var strdate = ""
                                    var strMonth = ""
                                    for i in 0..<self.newDataArray.count{
                                        
                                        let dict1 = self.newDataArray[i] as! [String: Any]
                                        var timeStamp = NSNumber()
                                        if  var time1 = (self.newDataArray[i] as AnyObject).value(forKey: "datenTime") as? NSNumber{
                                            
                                            timeStamp = time1
                                            
                                        }else
                                        {
                                            //timeStamp = 1558697575000
                                            
                                        }
                                        
                                        
                                        //                                        let timeStamp = (self.newDataArray[i] as AnyObject).value(forKey: "datenTime") as! Int
                                        let timeDouble = Double(timeStamp)
                                        
                                        let unixTimeStamp: Double = timeDouble / 1000.0
                                        let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "MMM d, yyyy"
                                        let dateString = dateFormatter.string(from: exactDate)
                                        print(dateString)
                                        dateFormatter.dateFormat = "MMM yyyy"
                                        let month = dateFormatter.string(from: exactDate)
                                        if strMonth == ""{
                                            strdate = dateString
                                            strMonth = month
                                            arrayLevel1.append(dict1)
                                            if self.newDataArray.count == 1 {
                                                let dictLev2 = [ strdate as! String: arrayLevel1];
                                                self.arrayLevel_All_Data.append(dictLev2)
                                                arrayLevel1.removeAll()
                                            }
                                        }
                                        else if month == strMonth{
                                            arrayLevel1.append(dict1)
                                            
                                            if self.newDataArray.count == i + 1{
                                                
                                                let dictLev2 = [ strdate as! String: arrayLevel1]; self.arrayLevel_All_Data.append(dictLev2)
                                                arrayLevel1.removeAll()
                                            }
                                        }
                                        else{
                                            
                                            
                                            let dictLev2 = [ strdate as! String: arrayLevel1]
                                            
                                            arrayLevel1.removeAll()
                                            self.arrayLevel_All_Data.append(dictLev2)
                                            
                                            if self.newDataArray.count == i + 1{
                                                
                                                arrayLevel1.append(dict1)
                                                strMonth = month
                                                strdate = dateString
                                                let dictLev2 = [ strdate as! String: arrayLevel1];
                                                self.arrayLevel_All_Data.append(dictLev2)
                                                arrayLevel1.removeAll()
                                                print(self.arrayLevel_All_Data)
                                                self.tableVW.reloadData()
                                                
                                                return
                                            }
                                            else{
                                                arrayLevel1.append(dict1)
                                                strdate = dateString
                                                strMonth = month
                                            }
                                        }
                                        
                                        
                                    }
                                    print(self.arrayLevel_All_Data)
                                    
                                    
                                    self.tableVW.reloadData()
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
    
    
    
    // MARK: - Function
    
    func stringToSeconds(_ time: String) -> Date{
        
        let unixTimeStamp: Double = Double(time)! / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let dateFormatt = DateFormatter();
        dateFormatt.dateFormat = "dd/MM/yyy hh:mm a"
        
        return exactDate as Date
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.arrayLevel_All_Data.count > 0{
            var visible: [AnyObject] = tableVW.indexPathsForVisibleRows! as [AnyObject]
            
            let sections = tableVW.indexPathsForVisibleRows?.map { $0.section } ?? []
            for section in sections {
                //print(String(format: "%d", section))
                if section == arrayLevel_All_Data.count - 1{
                    if(!isPageRefresing){ // no need to worry about threads because this is always on main thread.
                        
                        isPageRefresing = true
                        
                        fromIndex = fromIndex + 1
                        getGlucoseApi(getData: fromIndex)
                    }
                }
                
                
            }
        }
        
    }
    
    
    
    
    // MARK: - Table View Delegate Method
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrayLevel_All_Data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var array2 = [[String:Any]]()
        
        array2 = [self.arrayLevel_All_Data[section] as [String : Any]]
        // return dataArray.count
        var array3 = NSArray()
        var dict1 = NSDictionary()
        
        dict1 = array2[0] as NSDictionary
        
        if dict1.allKeys.count == 1
        {
            
            array3 = (dict1.value(forKey: dict1.allKeys[0] as! String) as? NSArray)!
        }
        
        return array3.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlucoseCell") as! GlucoseCell
        
        var search_parent_Array = NSMutableArray()
        
        
        var array2 = [[String:Any]]()
        var array3 = NSArray()
        
        array2 = [self.arrayLevel_All_Data[indexPath.section] as [String : Any]]
        
        
        var dict1 = NSDictionary()
        
        dict1 = array2[0] as NSDictionary
        
        if dict1.allKeys.count == 1
        {
            
            array3 = (dict1.value(forKey: dict1.allKeys[0] as! String) as? NSArray)!
        }
        
        var dict14 = NSDictionary()
        
        for i in 0..<array3.count {
            dict14 = array3[i] as! NSDictionary
            print(dict14)
            search_parent_Array.add(dict14)
        }
        
        
        
        cell.txtVW.text = ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "note") as? String)
        if cell.txtVW.text == "" {
            cell.lblComment.isHidden = true
        } else {
            cell.lblComment.isHidden = false
        }
        var measurementIntVal = Int()
        
        measurementIntVal = ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "measurement") as? Int ?? 0)
        var measurement = String(measurementIntVal)
        cell.lblMeasurement.text = measurement
        cell.lblContext.text = ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "measurementContext") as? String)
        cell.lblType.text = ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "measurementType") as? String)
        let timeStamp = (search_parent_Array[indexPath.row] as AnyObject).value(forKey: "datenTime") as! NSNumber
        let timeDouble = Double(timeStamp)
        
        let unixTimeStamp: Double = timeDouble / 1000.0
        let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        let dateString = dateFormatter.string(from: exactDate)
        
        cell.lblDate.text = dateString
        
        if let deviceID = (search_parent_Array[indexPath.row] as AnyObject).value(forKey: "deviceId") as? String {
            if deviceID != "" && deviceID != "<null>" {
                cell.imgVw.image = UIImage.init(named: "bluetooth_Icon")
            }
            else {
//                if ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "enteredBy") as? NSNumber) == ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "personID") as? NSNumber) {
                    cell.imgVw.image = UIImage.init(named: "profile_Icon")
//                }
//                else {
//                    cell.imgVw.image = UIImage.init(named: "emr_Icon")
//                }
            }
        }
//        else if (search_parent_Array[indexPath.row] as AnyObject).value(forKey: "deviceId") != nil {
//            cell.imgVw.image = UIImage.init(named: "bluetooth_Icon")
//        }
        else {
//            if ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "enteredBy") as? NSNumber) == ((search_parent_Array[indexPath.row] as AnyObject).value(forKey: "personID") as? NSNumber) {
                cell.imgVw.image = UIImage.init(named: "profile_Icon")
//            }
//            else {
//                cell.imgVw.image = UIImage.init(named: "emr_Icon")
//            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //    return ((dataArray[indexPath.row] as AnyObject).value(forKey: "note") as? String)!
        //        .heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 14))
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        
        tableVW.deselectRow(at: indexPath, animated: true)
        
        
        self.intSection = indexPath.section
        var newArray = [[String:Any]]()
        newArray = [self.arrayLevel_All_Data[intSection] ]
        
        var array2 = [[String:Any]]()
        
        array2 = [self.arrayLevel_All_Data[intSection] as [String : Any]]
        // return dataArray.count
        
        print([self.arrayLevel_All_Data[intSection] as [String : Any]])
        var array3 = NSMutableArray()
        var dict1 = NSDictionary()
        
        dict1 = array2[0] as NSDictionary
        
        if dict1.allKeys.count == 1
        {
            var array4 = NSArray()
            
            array4 = (dict1.value(forKey: dict1.allKeys[0] as! String) as? NSArray)!
            
            
            array3 = NSMutableArray.init(array: array4)
            print(array3.count)
            
        }
        
        if let deviceID = (array3[indexPath.row] as AnyObject).value(forKey: "deviceId") as? String {
            if deviceID != "" {
            }
            else {
                let controller = storyboard?.instantiateViewController(withIdentifier: "AdditionalGlucoseVC") as! AdditionalGlucoseVC
                controller.dictDate = array3[indexPath.row] as! NSDictionary
                controller.putOrPost = true
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
//        else if (array3[indexPath.row] as AnyObject).value(forKey: "deviceId") != nil {
//        }
        else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "AdditionalGlucoseVC") as! AdditionalGlucoseVC
            controller.dictDate = array3[indexPath.row] as! NSDictionary
            controller.putOrPost = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 64))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 15, width: headerView.frame.width-20, height: 30)
        
        let labelLine = UILabel()
        labelLine.frame = CGRect.init(x: 10, y: 55, width: headerView.frame.width-20, height: 2)
        
        
        var array2 = [[String:Any]]()
        array2 = [self.arrayLevel_All_Data[section] as [String : Any]]
        
        var dict1 = NSDictionary()
        
        dict1 = array2[0] as NSDictionary
        
        if dict1.allKeys.count == 1
        {
            
            var strDate = dict1.allKeys[0] as! String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let date = dateFormatter.date(from: strDate)
            
            if date != nil{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                let dateString = dateFormatter.string(from: date!)
                
                print(dateString)
                label.text = dateString
            }
            
            
        }
        
        
        
        label.textColor = UIColor(red: 0.0/255, green: 148.0/255, blue: 127.0/255, alpha: 1.0)
        labelLine.backgroundColor = UIColor(red: 0.0/255, green: 148.0/255, blue: 127.0/255, alpha: 1.0)
        
        headerView.backgroundColor = UIColor.white
        
        headerView.addSubview(label)
        headerView.addSubview(labelLine)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        self.intSection = indexPath.section
        
        let array2 = [self.arrayLevel_All_Data[intSection] as [String : Any]]
        
        var array3 = NSMutableArray()
        var dict1 = NSDictionary()
        
        dict1 = array2[0] as NSDictionary
        
        if dict1.allKeys.count == 1
        {
            var array4 = NSArray()
            
            array4 = (dict1.value(forKey: dict1.allKeys[0] as! String) as? NSArray)!
            
            
            array3 = NSMutableArray.init(array: array4)
            print(array3.count)
            
        }
        if let deviceID = (array3[indexPath.row] as AnyObject).value(forKey: "deviceId") as? String {
            if deviceID != "" {
                return false
            }
            else {
                return true
            }
        }
//        else if (array3[indexPath.row] as AnyObject).value(forKey: "deviceId") != nil {
//            return false
//        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            // Deleting new item in the table
            self.intSection = indexPath.section
            var newArray = [[String:Any]]()
            newArray = [self.arrayLevel_All_Data[intSection] ]
            
            var array2 = [[String:Any]]()
            
            array2 = [self.arrayLevel_All_Data[intSection] as [String : Any]]
            // return dataArray.count
            
            print([self.arrayLevel_All_Data[intSection] as [String : Any]])
            var array3 = NSMutableArray()
            var dict1 = NSDictionary()
            
            dict1 = array2[0] as NSDictionary
            
            if dict1.allKeys.count == 1
            {
                var array4 = NSArray()
                
                array4 = (dict1.value(forKey: dict1.allKeys[0] as! String) as? NSArray)!
                
                
                array3 = NSMutableArray.init(array: array4)
                print(array3.count)
                
            }
            
            
            var deviceIP = String()
            var deviceID = String()
            
            var glucoseTestID = Int()
            var measurement = Int()
            var datenTime = NSNumber()
            var measurementContext = String()
            var measurementType = String()
            var note = String()
            var personID = Int()
            var enteredBy = Int()
            var source = String()
            
            glucoseTestID = ((array3[indexPath.row] as AnyObject).value(forKey: "glucoseTestID") as? Int)!
            measurement = ((array3[indexPath.row] as AnyObject).value(forKey: "measurement") as? Int)!
            datenTime = ((array3[indexPath.row] as AnyObject).value(forKey: "datenTime") as? NSNumber)!
            measurementContext = ((array3[indexPath.row] as AnyObject).value(forKey: "measurementContext") as? String)!
            measurementType = ((array3[indexPath.row] as AnyObject).value(forKey: "measurementType") as? String)!
            note = ((array3[indexPath.row] as AnyObject).value(forKey: "note") as? String)!
            personID = ((array3[indexPath.row] as AnyObject).value(forKey: "personID") as? Int)!
            enteredBy = ((array3[indexPath.row] as AnyObject).value(forKey: "enteredBy") as? Int)!
            source = ((array3[indexPath.row] as AnyObject).value(forKey: "source") as? String)!
            
            callDeleteApi(_glucoseTestID: glucoseTestID, _measurement: measurement, _datenTime: datenTime, _measurementContext: measurementContext, _measurementType: measurementType, _note: note, _personID: personID, _enteredBy:enteredBy, _source:source )
            
            
            if array3.count == 1{
                self.arrayLevel_All_Data.remove(at: intSection)
                
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableVW.beginUpdates()
                tableVW.deleteSections(indexSet, with: .automatic)
                
                tableVW.endUpdates()
                
                
                
            }else{
                
                array3.removeObject(at: indexPath.row)
                
                self.arrayLevel_All_Data.remove(at: intSection)
                
                var strDate = dict1.allKeys[0] as! String
                
                
                let dictLev2 = [ strDate as! String: array3];
                
                self.arrayLevel_All_Data.insert(dictLev2 as! [String : Any], at: intSection)
                
                
                print([self.arrayLevel_All_Data[intSection] as [String : Any]])
                
                tableVW.beginUpdates()
                tableVW.deleteRows(at: [indexPath], with: .automatic)
                
                tableVW.endUpdates()
                
            }
            
            //  tableVW.reloadData()
            
        }
        
        
        
        
        
    }
    
    
    // MARK: - Delete Api
    
    func callDeleteApi(_glucoseTestID: Int,_measurement: Int,_datenTime: NSNumber,_measurementContext: String,_measurementType: String,_note: String,_personID: Int,_enteredBy: Int,_source: String ){
        hud.show(animated: true)
        let headers: [String:Any] = ["X-Auth-Token": self.authToken,"content-type": "application/json"]
        var postData =  Data()
        //        let str = String(format:"%d",_WeightId)
        let parameters = [
            "glucoseTestID": _glucoseTestID,
            "measurement": _measurement,
            "datenTime": _datenTime,
            "comparision": "",
            "controlTest": "",
            "outsideTemperatureRange": "",
            "measurementContext": _measurementContext,
            "measurementType": _measurementType,
            "note": _note,
            "personID": _personID,
            "enteredBy": _enteredBy,
            "deviceIP": "12.5",
            "deviceID": "",
            "visitId": "1",
            "source": _source
            ] as [String : Any]
        
        
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            
            //try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/glucose/\(_glucoseTestID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "DELETE"
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
                        if let json = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        {
                            print("\(String(describing: json))")
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                
                                
                                if json == "true" {
                                    
                                    let alert = UIAlertController(title: "Successs", message:
                                        "Glucose object has been deleted successfully", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    //                                    self.getWeightApi()
                                    
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
    
    private func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    // MARK: - Button Action
    
    @IBAction func btnGraph(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "GlucoseGraphVc") as!GlucoseGraphVc
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Add(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdditionalGlucoseVC") as! AdditionalGlucoseVC
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}