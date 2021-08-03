//
//  PulseoximeterGraphVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 05/06/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD
class PulseoximeterGraphVc: UIViewController {

    @IBOutlet weak var lblSpo2: UILabel!
    
    @IBOutlet weak var lblPr: UILabel!
    
    @IBOutlet weak var chartVw: LineChartView!
    
    
    @IBOutlet weak var lblDate: UILabel!
    

    
    
    
    var lineChartEntry = [ChartDataEntry]()
    var lineChartEntry2 = [ChartDataEntry]()
    var lineChartEntry3 = [ChartDataEntry]()
    var total = NSMutableArray()
    var total2 = NSMutableArray()
//    var total3 = NSMutableArray()
    var dataArray = NSMutableArray()
     var listArray = NSArray()
    var spo2IntVal = Int()
    var prIntVal = Int()
//    var pulseIntVal = Int()
    var arrayLevel_All_Data = [[String:Any]]()
    var dataDict = NSDictionary()
    var Array1 = NSArray()
    var Array2 = NSArray()
    var dict1 = NSDictionary()
    //var months: [String]!
    var months =  NSMutableArray()
    var dateString = String()
    var monthDate = String()
    
    var dateTime = NSNumber()
    var totalReverse = NSMutableArray()
    var total2Reverse  = NSMutableArray()
    var monthsReverse =  NSMutableArray()
    var hud  = MBProgressHUD()
    var allChartArray = NSMutableArray()
    var pulseoximeterArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        getPulseoximeterApi_LineChart()
        
//        let recovedUserJsonData = UserDefaults.standard.object(forKey: "PulsexometerDict")
//
//        if  recovedUserJsonData == nil{
//            //apiCalling()
//            return
//        }
//
//        let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
//        if recovedUserJson == nil{
//            // apiCalling()
//            return
//        }
//
//
////        arrayLevel_All_Data = recovedUserJson! as! [[String:Any]]
////        print(arrayLevel_All_Data)
//
//        listArray = recovedUserJson! as! NSArray
//        print(listArray)
//
//        self.arrayLevel_All_Data.removeAll()
//        var arrayLevel2 = [[String:Any]]()
//        var arrayLevel1 = [[String:Any]]()
//
//        var strdate = String()
//
//        strdate = ""
//        for i in 0..<self.listArray.count{
//
//            let dict1 = self.listArray[i] as! [String: Any]
//            let timeStamp = (self.listArray[i] as AnyObject).value(forKey: "datenTime") as! Int
//            let timeDouble = Double(timeStamp)
//
//            let unixTimeStamp: Double = timeDouble / 1000.0
//            let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM,yyyy"
//            let dateString = dateFormatter.string(from: exactDate)
//            print(dateString)
//            if strdate == ""{
//                strdate = dateString
//                arrayLevel1.append(dict1)
//            }
//            else if dateString == strdate{
//                arrayLevel1.append(dict1)
//
//                if self.listArray.count == i + 1{
//
//                    let dictLev2 = [ strdate as! String: arrayLevel1]; self.arrayLevel_All_Data.append(dictLev2)
//                    arrayLevel1.removeAll()
//                }
//            }
//            else{
//
//
//                let dictLev2 = [ strdate as! String: arrayLevel1]
//
//                arrayLevel1.removeAll()
//                self.arrayLevel_All_Data.append(dictLev2)
//
//                if self.listArray.count == i + 1{
//
//                    arrayLevel1.append(dict1)
//
//                    strdate = dateString
//                    let dictLev2 = [ strdate as! String: arrayLevel1];
//                    self.arrayLevel_All_Data.append(dictLev2)
//                    arrayLevel1.removeAll()
//                    print(self.arrayLevel_All_Data)
//
//
//                    return
//                }
//                else{
//                    arrayLevel1.append(dict1)
//                    strdate = dateString
//                }
//            }
//
//
//        }
//
//        print(self.arrayLevel_All_Data)
//
//        self.dataArray = NSMutableArray.init(array: self.arrayLevel_All_Data)
//        // print(self.dataArray)
//
//        dataDict = self.dataArray.object(at: 0) as! NSDictionary
//
//        Array1 = dataDict.allValues as NSArray
//        print(Array1)
//        Array2 = Array1.object(at: 0) as! NSArray
//        print(Array2)
//        for i in 0..<Array2.count{
//            dict1 = self.Array2.object(at: i) as! NSDictionary
//
//
//
//            spo2IntVal = dict1.value(forKey: "spo2") as! Int
//            prIntVal = dict1.value(forKey: "pr") as! Int
////            pulseIntVal = dict1.value(forKey: "pulse") as! Int
//            dateTime = dict1.value(forKey: "datenTime") as! Int
//            let timeDouble = Double(dateTime)
//
//            let unixTimeStamp: Double = timeDouble / 1000.0
//            let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
//            dateString = dateFormatter.string(from: exactDate)
//            print(dateString)
//
//
//
//
//            total.add(spo2IntVal)
//            total2.add(prIntVal)
//            let Formatter = DateFormatter()
//            Formatter.dateFormat = "MMM d, yyyy, h:mm a"
//            let date = Formatter.date(from: dateString)
//
//            if date != nil{
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd.MM.yyyy"
//                let dateString1 = dateFormatter.string(from: date!)
//
//                print(dateString1)
//                monthDate = dateString1
//                lblDate.text = dateString
//            }
//
//            lblSpo2.text = String(spo2IntVal)
//            lblPr.text = String(prIntVal)
//            //        lblBpVal.text = String(pulseIntVal)
//            months.add(monthDate)
////            total3.add(pulseIntVal)
//        }
//            totalReverse = NSMutableArray.init(array: total.reversed())
//            total2Reverse = NSMutableArray.init(array: total2.reversed())
//
//            monthsReverse = NSMutableArray.init(array: months.reversed())
//
//            for i in 0..<Array2.count{
//                var dict2 = NSDictionary()
//                var systolicValue = Int()
//                var diastolicValue = Int()
//                var pulseValue = Int()
//                var datenTime2 = Int()
//                dict2 = self.Array2.object(at: 0) as! NSDictionary
//                systolicValue = dict2.value(forKey: "spo2") as! Int
//                diastolicValue = dict2.value(forKey: "pr") as! Int
//
//                lblSpo2.text = String(systolicValue)
//                lblPr.text = String(diastolicValue)
//
//                datenTime2 = dict2.value(forKey: "datenTime") as! Int
//                let timeDouble = Double(datenTime2)
//
//                let unixTimeStamp: Double = timeDouble / 1000.0
//                let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
//                let dateString1 = dateFormatter.string(from: exactDate)
//                print(dateString1)
//                lblDate.text = dateString1
//
//            }
//
//        for i in 0..<total.count{
//            var values = ChartDataEntry(x: Double(i), y: totalReverse[i] as! Double)
//
//            lineChartEntry.append(values)
//
//
//        }
//        for i in 0..<total2.count{
//            var values2 = ChartDataEntry(x: Double(i) , y: total2Reverse[i] as! Double)
//            lineChartEntry2.append(values2)
//        }
////        for i in 0..<total3.count{
////            var values3 = ChartDataEntry(x: Double(i) , y: total3[i] as! Double)
////            lineChartEntry3.append(values3)
////        }
//
//        let line1 = LineChartDataSet(entries: lineChartEntry,label : "spo2")
//        let line2 = LineChartDataSet(entries: lineChartEntry2,label : "pr")
////        let line3 = LineChartDataSet(entries: lineChartEntry3,label : "pulse in bpm")
//
//        line2.setCircleColor(UIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0))
//        line1.setCircleColor(UIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0))
////        line3.setCircleColor(UIColor(red: 0/255.00, green: 154/255.00, blue: 132/255.00, alpha: 1.0))
////        line3.drawCircleHoleEnabled = false
//        line2.drawCircleHoleEnabled = false
//        line1.drawCircleHoleEnabled = false
//        line1.circleRadius = 6.0
//        line1.circleHoleRadius = 0.0
//        line2.circleRadius = 6.0
//        line2.circleHoleRadius = 0.0
////        line3.circleRadius = 6.0
////        line3.circleHoleRadius = 0.0
//        line1.colors = [NSUIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0)]
//        line2.colors = [NSUIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0)]
//        //line3.colors = [NSUIColor(red: 0/255.00, green: 154/255.00, blue: 132/255.00, alpha: 1.0)]
//        let data = LineChartData()
//
//
//        data.addDataSet(line1)
//        data.addDataSet(line2)
//       // data.addDataSet(line3)
//        chartVw.data = data
//
//        chartVw.xAxis.valueFormatter = IndexAxisValueFormatter(values:monthsReverse as! [String])
//        chartVw.leftAxis.axisMinimum = 0
//        chartVw.leftAxis.axisMaximum = 150
//        chartVw.rightAxis.enabled = false
//
//        chartVw.xAxis.labelPosition = .bottom
//        chartVw.scaleXEnabled = false
//        chartVw.scaleYEnabled = false
//        chartVw.xAxis.drawGridLinesEnabled = false
//        chartVw.leftAxis.drawGridLinesEnabled = true
//
//        chartVw.leftAxis.labelCount = 3
//        chartVw.xAxis.setLabelCount(2, force: true)
//        chartVw.leftAxis.axisLineColor = UIColor.black
//        chartVw.xAxis.axisLineColor = UIColor.black
//        line1.lineWidth = 4
//        line2.lineWidth = 4
//        //line3.lineWidth = 4
//        line1.drawValuesEnabled = false
//        line2.drawValuesEnabled = false
//        //line3.drawValuesEnabled = false
//
//
//        //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
//        let legend = chartVw.legend
//        legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
//        legend.xEntrySpace = 20
//        legend.yEntrySpace = 10
//        legend.xOffset = 0
//        legend.yOffset = 0
//        chartVw.xAxis.avoidFirstLastClippingEnabled = true
        
    }
    
    // MARK: - Get Api
    
    
    func getPulseoximeterApi_LineChart(){
        hud.show(animated: true)
        
        var personID = Int()
        personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        
        var authToken = ""
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        var  url = ""
        url = BaseUrl as! String
        let headers: [String:Any] = ["X-Auth-Token":authToken]
        
        // http://40.79.35.122:8081/emrmega/api/bloodpressure/alllastreading/1
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/bloodpressure/alllastreading/\(personID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //     print(String.init(data: data!, encoding: .utf8) as Any)
            
            
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hud.hide(animated: true)
                }
            } else {
                
                if(response != nil && data != nil ) {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let array = json  as? NSArray {
                            DispatchQueue.main.async {
                                self.hud.hide(animated: true)
                                self.allChartArray.addObjects(from: array as [AnyObject])
                                print(self.allChartArray)
                                
                                
                                for i in 0..<self.allChartArray.count{
                                    
                                    var dict1 = NSDictionary()
                                    dict1 = self.allChartArray[i]  as! NSDictionary
                                    
                                    var strName = String()
                                    strName = dict1.value(forKey: "componetName") as! String
                                    if strName  == "pulseoximeter"{
                                        var array = dict1.value(forKey: "readings") as! NSArray
                                        array = array.reversed() as NSArray
                                        
                                        self.pulseoximeterArray.addObjects(from: array as [AnyObject])
                                        print(self.pulseoximeterArray)
                                    }
                                    
                                    
                                }
                                for i in 0..<self.pulseoximeterArray.count{
                                    
                                    var dict1 = NSDictionary ()
                                    dict1 = self.pulseoximeterArray.object(at: i) as! NSDictionary
                                    
                                    self.spo2IntVal = dict1.value(forKey: "spo2") as! Int
                                    self.prIntVal = dict1.value(forKey: "pr") as! Int
                                    
                                    self.dateTime = dict1.value(forKey: "datenTime") as! NSNumber
                                    let timeDouble = Double(self.dateTime)
                                    
                                    let unixTimeStamp: Double = timeDouble / 1000.0
                                    let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
                                    
                                    var dateString = ""
                                    dateString = dateFormatter.string(from: exactDate)
                                    print(dateString)
                                    if i == self.pulseoximeterArray.count - 1{
                                        self.lblSpo2.text = String(self.spo2IntVal)
                                        self.lblPr.text = String(self.prIntVal)
                                        self.lblDate.text = dateString
                                    }
                                    
                                    let Formatter = DateFormatter()
                                    Formatter.dateFormat = "MMM d, yyyy, h:mm a"
                                    let date = Formatter.date(from: dateString)
                                    var monthDate = String()
                                    
                                    if date != nil{
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd.MM.yyyy"
                                        let dateString1 = dateFormatter.string(from: date!)
                                        
                                        print(dateString1)
                                        monthDate = dateString1
                                        //                lblDate.text = dateString
                                    }
                                    
                                    self.months.add(monthDate)
                                    
                                    self.total .add(self.spo2IntVal)
                                    self.total2.add(self.prIntVal)
                                    
                                    
                                    
                                }
                                for i in 0..<self.total.count{
                                    var values = ChartDataEntry(x: Double(i), y: self.total[i] as! Double)
                                    
                                    self.lineChartEntry.append(values)
                                    
                                    
                                }
                                for i in 0..<self.total2.count{
                                    var values2 = ChartDataEntry(x: Double(i) , y: self.total2[i] as! Double)
                                    self.lineChartEntry2.append(values2)
                                }
                                
                                
                                let line1 = LineChartDataSet(entries: self.lineChartEntry,label : "spo2")
                                let line2 = LineChartDataSet(entries: self.lineChartEntry2,label : "pr")
                                
                                line2.setCircleColor(UIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0))
                                line1.setCircleColor(UIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0))
                                
                                
                                line2.drawCircleHoleEnabled = false
                                line1.drawCircleHoleEnabled = false
                                line1.circleRadius = 6.0
                                line1.circleHoleRadius = 0.0
                                line2.circleRadius = 6.0
                                line2.circleHoleRadius = 0.0
                                
                                line1.colors = [NSUIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0)]
                                line2.colors = [NSUIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0)]
                                
                                let data = LineChartData()
                                
                                
                                data.addDataSet(line1)
                                data.addDataSet(line2)
                                
                                self.chartVw.data = data
                                
                                self.chartVw.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.months as! [String])
                                self.chartVw.leftAxis.axisMinimum = 0
                                self.chartVw.leftAxis.axisMaximum = 150
                                self.chartVw.rightAxis.enabled = false
                                
                                self.chartVw.xAxis.labelPosition = .bottom
                                self.chartVw.scaleXEnabled = false
                                self.chartVw.scaleYEnabled = false
                                self.chartVw.xAxis.drawGridLinesEnabled = false
                                self.chartVw.leftAxis.drawGridLinesEnabled = true
                                
                                self.chartVw.leftAxis.labelCount = 3
                                self.chartVw.xAxis.setLabelCount(2, force: true)
                                self.chartVw.leftAxis.axisLineColor = UIColor.black
                                self.chartVw.xAxis.axisLineColor = UIColor.black
                                line1.lineWidth = 4
                                line2.lineWidth = 4
                                
                                line1.drawValuesEnabled = false
                                line2.drawValuesEnabled = false
                                
                                
                                
                                //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
                                let legend = self.chartVw.legend
                                legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                                legend.xEntrySpace = 20
                                legend.yEntrySpace = 10
                                legend.xOffset = 0
                                legend.yOffset = 0
                                self.chartVw.xAxis.avoidFirstLastClippingEnabled = true
                                
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
    
    // MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
