//
//  DashboardVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

class DashboardVc: UIViewController , UITableViewDelegate, UITableViewDataSource{
 
    
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    
    var months: [String]!
    var viewHasMovedToRight = Bool()
    
    var isbloodPressure = Bool()

    var hud  = MBProgressHUD()
    
    var allChartArray = NSMutableArray()
    var bloodPressureArray = NSMutableArray()
    var glucoseArray = NSMutableArray()
    var pulseoximeterArray = NSMutableArray()
    var weightArray = NSMutableArray()
    var imageurl = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        self.navigationController?.navigationBar.isHidden = true

        let recovedUserJsonData = UserDefaults.standard.object(forKey: "LoginDict")
        
        if  recovedUserJsonData == nil{
            //apiCalling()
            return
        }
        
        let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
        if recovedUserJson == nil{
            return
        }
        
        let dict = recovedUserJson! as! NSDictionary
        print(dict)
        var name = ""
        if let firstname = dict.value(forKey: "firstName") as? String{
             name = firstname
        }
        if let middlename = dict.value(forKey: "middleName") as? String{
            name.append(String(format:" %@", middlename))
        }
        if let lastname = dict.value(forKey: "lastName") as? String{
            name.append(String(format:" %@", lastname))
        }
        self.lblName.text = name
        
        self.tableVw.separatorStyle = .none
        tableVw.delegate = self
        tableVw.dataSource = self
        months = ["03.01.2019", "02.02.2019","04.03.2019","10.04.2019","04.05.2019"]
        if viewHasMovedToRight == true{
            btnBackOutlet.setImage(#imageLiteral(resourceName: "back_Icon"), for: .normal)
        } else {
            btnBackOutlet.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }
        hud = MBProgressHUD.showAdded(to: view, animated: true)

        getBloodpressureApi_Dashboard()
        
        imageurl = UserDefaults.standard.value(forKey: "ImageUrl") as! String
        
        if imageurl != ""{
          self.imgVwProfile.sd_setImage(with: URL(string: imageurl), placeholderImage: nil)
        }
        
    }
    
    
    // MARK: - Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // if bloodPressureArray.count > 0 {
            return 4
       // }
      //   return 0
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableVw.dequeueReusableCell(withIdentifier: "dashboardCell") as! DashboardTvc
        
        
        if indexPath.row == 0{
            
            var lineChartEntry = [ChartDataEntry]()
            var lineChartEntry2 = [ChartDataEntry]()
            var lineChartEntry3 = [ChartDataEntry]()
            let monthsB =  NSMutableArray()

            let total = NSMutableArray()
            let total2 = NSMutableArray()
            let total3 = NSMutableArray()
            
            if bloodPressureArray.count == 0{
                cell.lbeSy.text = ""
                cell.lbeDia.text = ""
                cell.lbePul.text = ""
                cell.lbeDate.text = ""
            }
            
            for i in 0..<bloodPressureArray.count{

                    var dict1 = NSDictionary ()
                    dict1 = bloodPressureArray.object(at: i) as! NSDictionary


                    var systolicIntVal = Int()
                    var diastolicIntVal = Int()
                    var pulseIntVal = Int()
                    var dateTime = NSNumber()


                    systolicIntVal = dict1.value(forKey: "systolic") as! Int
                    diastolicIntVal = dict1.value(forKey: "diastolic") as! Int
                    pulseIntVal = dict1.value(forKey: "pulse") as! Int
                    dateTime = dict1.value(forKey: "datenTime") as! NSNumber
                    let timeDouble = Double(dateTime)

                    let unixTimeStamp: Double = timeDouble / 1000.0
                    let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"

                    var dateString = ""
                    dateString = dateFormatter.string(from: exactDate)
                    print(dateString)
                    if i == bloodPressureArray.count - 1{
                    cell.lbeSy.text = String(systolicIntVal)
                    cell.lbeDia.text = String(diastolicIntVal)
                    cell.lbePul.text = String(pulseIntVal)
                    cell.lbeDate.text = dateString
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
                
                    monthsB.add(monthDate)

                    total .add(systolicIntVal)
                    total2.add(diastolicIntVal)
                    total3.add(pulseIntVal)


            }
            
            
            cell.lbeTitalChart.text = "Blood Pressure"
            for i in 0..<total.count {
                var values = ChartDataEntry(x: Double(i), y: total[i] as! Double)
                
                lineChartEntry.append(values)
                
                
            }
            for i in 0..<total2.count{
                var values2 = ChartDataEntry(x: Double(i) , y: total2[i] as! Double)
                lineChartEntry2.append(values2)
            }
            for i in 0..<total3.count{
                var values3 = ChartDataEntry(x: Double(i) , y: total3[i] as! Double)
                lineChartEntry3.append(values3)
            }
            
            let line1 = LineChartDataSet(entries: lineChartEntry,label : "systolic in mmg")
            let line2 = LineChartDataSet(entries: lineChartEntry2,label : "diastolic in mmg")
            let line3 = LineChartDataSet(entries: lineChartEntry3,label : "pulse in bpm")
            
            
            
            line2.setCircleColor(UIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0))
            line1.setCircleColor(UIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0))
            line3.setCircleColor(UIColor(red: 0/255.00, green: 154/255.00, blue: 132/255.00, alpha: 1.0))
            line3.drawCircleHoleEnabled = false
            line2.drawCircleHoleEnabled = false
            line1.drawCircleHoleEnabled = false
            line1.circleRadius = 6.0
            line1.circleHoleRadius = 0.0
            line2.circleRadius = 6.0
            line2.circleHoleRadius = 0.0
            line3.circleRadius = 6.0
            line3.circleHoleRadius = 0.0
            line1.colors = [NSUIColor(red: 22/255.00, green: 187/255.00, blue: 255/255.00, alpha: 1.0)]
            line2.colors = [NSUIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0)]
            line3.colors = [NSUIColor(red: 0/255.00, green: 154/255.00, blue: 132/255.00, alpha: 1.0)]
            let data = LineChartData()
            
            
            data.addDataSet(line1)
            data.addDataSet(line2)
            data.addDataSet(line3)
            cell.lineChart.data = data

            cell.lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:monthsB as! [String])
            cell.lineChart.leftAxis.axisMinimum = 0
            cell.lineChart.leftAxis.axisMaximum = 150
            cell.lineChart.rightAxis.enabled = false
            
            cell.lineChart.xAxis.labelPosition = .bottom
            cell.lineChart.scaleXEnabled = false
            cell.lineChart.scaleYEnabled = false
            cell.lineChart.xAxis.drawGridLinesEnabled = false
            cell.lineChart.leftAxis.drawGridLinesEnabled = true
            
            cell.lineChart.leftAxis.labelCount = 3
            cell.lineChart.xAxis.setLabelCount(2, force: true)
            cell.lineChart.leftAxis.axisLineColor = UIColor.black
            cell.lineChart.xAxis.axisLineColor = UIColor.black
            line1.lineWidth = 4
            line2.lineWidth = 4
            line3.lineWidth = 4
            line1.drawValuesEnabled = false
            line2.drawValuesEnabled = false
            line3.drawValuesEnabled = false
            
            
            //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
            let legend = cell.lineChart.legend
            legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            legend.xEntrySpace = 20
            legend.yEntrySpace = 10
            legend.xOffset = 0
            legend.yOffset = 0
            cell.lineChart.xAxis.avoidFirstLastClippingEnabled = true
           
            
        
    }
        
        
        
        if indexPath.row == 1{
//            cell.total = [75,128,140]
//            cell.total2 = [128,85,90]
//            cell.total3 = [75,80,70]
            
            if glucoseArray.count == 0{
                cell.lbeSy.text = ""
                cell.lbeDia.text = ""
                cell.lbePul.text = ""
                cell.lbeDate.text = ""
            }
            
            
            var lineChartEntry = [ChartDataEntry]()
            var lineChartEntry2 = [ChartDataEntry]()
            var lineChartEntry3 = [ChartDataEntry]()
            
            var total = NSMutableArray()
            var total2 = NSMutableArray()
            var total3 = NSMutableArray()
            
            var monthsB =  NSMutableArray()

            for i in 0..<glucoseArray.count{
                
                var dict1 = NSDictionary ()
                dict1 = glucoseArray.object(at: i) as! NSDictionary
                
                
                var systolicIntVal = Int()
             
                var dateTime = NSNumber()
                
                
                systolicIntVal = dict1.value(forKey: "measurement") as! Int
             
                dateTime = dict1.value(forKey: "datenTime") as! NSNumber
                let timeDouble = Double(dateTime)
                
                let unixTimeStamp: Double = timeDouble / 1000.0
                let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
                
                var dateString = ""
                dateString = dateFormatter.string(from: exactDate)
                print(dateString)
                if i == glucoseArray.count - 1{
                    cell.lbeSy.text = ""
                    cell.lbeDia.text = String(systolicIntVal)
                    cell.lbePul.text = ""
                    cell.lbeDate.text = dateString
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
                
                monthsB.add(monthDate)
                
                total .add(systolicIntVal)
                
                
                
            }
             cell.lbeTitalChart.text = "Glucose"
            for i in 0..<total.count {
                var values = ChartDataEntry(x: Double(i), y: total[i] as! Double)
                
                lineChartEntry.append(values)
                
                
            }
          
            
            let line1 = LineChartDataSet(entries: lineChartEntry,label : "measurement")
         
            
            line1.setCircleColor(UIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0))

            line1.drawCircleHoleEnabled = false
            line1.circleRadius = 6.0
            line1.circleHoleRadius = 0.0
           
            line1.colors = [NSUIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0)]
          
            let data = LineChartData()
            
            
            data.addDataSet(line1)
          
            cell.lineChart.data = data
            
            cell.lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:monthsB as! [String])
            cell.lineChart.leftAxis.axisMinimum = 0
            cell.lineChart.leftAxis.axisMaximum = 150
            cell.lineChart.rightAxis.enabled = false
            
            cell.lineChart.xAxis.labelPosition = .bottom
            cell.lineChart.scaleXEnabled = false
            cell.lineChart.scaleYEnabled = false
            cell.lineChart.xAxis.drawGridLinesEnabled = false
            cell.lineChart.leftAxis.drawGridLinesEnabled = true
            
            cell.lineChart.leftAxis.labelCount = 3
            cell.lineChart.xAxis.setLabelCount(2, force: true)
            cell.lineChart.leftAxis.axisLineColor = UIColor.black
            cell.lineChart.xAxis.axisLineColor = UIColor.black
            line1.lineWidth = 4
           
            line1.drawValuesEnabled = false
           
            
            
            //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
            let legend = cell.lineChart.legend
            legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            legend.xEntrySpace = 20
            legend.yEntrySpace = 10
            legend.xOffset = 0
            legend.yOffset = 0
            cell.lineChart.xAxis.avoidFirstLastClippingEnabled = true
            
            
            
        }
        

        
        if indexPath.row == 2{
            
            if weightArray.count == 0{
                cell.lbeSy.text = ""
                cell.lbeDia.text = ""
                cell.lbePul.text = ""
                cell.lbeDate.text = ""
            }
            
            
            // weight var lineChartEntry = [ChartDataEntry]()
            
            var lineChartEntry = [ChartDataEntry]()
            var lineChartEntry2 = [ChartDataEntry]()
            var lineChartEntry3 = [ChartDataEntry]()
            
            var total = NSMutableArray()
            var total2 = NSMutableArray()
            var total3 = NSMutableArray()
            var monthsB =  NSMutableArray()

            for i in 0..<weightArray.count{
                
                var dict1 = NSDictionary ()
                dict1 = weightArray.object(at: i) as! NSDictionary
                
                
                var systolicIntVal = Int()
                
                var dateTime = NSNumber()
                
                if ((dict1.value(forKey: "weight") as? Int) != nil) {
                    systolicIntVal = (dict1.value(forKey: "weight") as! Int)
                }
                else {
                    systolicIntVal = Int(dict1.value(forKey: "weight") as! NSNumber)
                }
                
                dateTime = dict1.value(forKey: "datenTime") as! NSNumber
                let timeDouble = Double(dateTime)
                
                let unixTimeStamp: Double = timeDouble / 1000.0
                let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
                
                var dateString = ""
                dateString = dateFormatter.string(from: exactDate)
                print(dateString)
                if i == weightArray.count - 1{
                    cell.lbeSy.text = ""
                    cell.lbeDia.text = String(systolicIntVal)
                    cell.lbePul.text = ""
                    cell.lbeDate.text = dateString
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
                
                monthsB.add(monthDate)
                total .add(systolicIntVal)
                
                
                
            }
            cell.lbeTitalChart.text = "Weight"
            for i in 0..<total.count {
                var values = ChartDataEntry(x: Double(i), y: total[i] as! Double)
                
                lineChartEntry.append(values)
                
                
            }
            
            
            let line1 = LineChartDataSet(entries: lineChartEntry,label : "weight in kg")
            
            
            
            line1.setCircleColor(UIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0))
            line1.drawCircleHoleEnabled = false
            line1.circleRadius = 6.0
            line1.circleHoleRadius = 0.0
            
            line1.colors = [NSUIColor(red: 244/255.00, green: 145/255.00, blue: 30/255.00, alpha: 1.0)]
            
            let data = LineChartData()
            
            
            data.addDataSet(line1)
            
            cell.lineChart.data = data
            
            cell.lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:monthsB as! [String])
            cell.lineChart.leftAxis.axisMinimum = 0
            cell.lineChart.leftAxis.axisMaximum = 150
            cell.lineChart.rightAxis.enabled = false
            
            cell.lineChart.xAxis.labelPosition = .bottom
            cell.lineChart.scaleXEnabled = false
            cell.lineChart.scaleYEnabled = false
            cell.lineChart.xAxis.drawGridLinesEnabled = false
            cell.lineChart.leftAxis.drawGridLinesEnabled = true
            
            cell.lineChart.leftAxis.labelCount = 3
            cell.lineChart.xAxis.setLabelCount(2, force: true)
            cell.lineChart.leftAxis.axisLineColor = UIColor.black
            cell.lineChart.xAxis.axisLineColor = UIColor.black
            line1.lineWidth = 4
            
            line1.drawValuesEnabled = false
            
            
            
            //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
            let legend = cell.lineChart.legend
            legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            legend.xEntrySpace = 20
            legend.yEntrySpace = 10
            legend.xOffset = 0
            legend.yOffset = 0
            cell.lineChart.xAxis.avoidFirstLastClippingEnabled = true
            
            
            
        }
        
        
        if indexPath.row == 3{
            
            
            if pulseoximeterArray.count == 0{
                cell.lbeSy.text = ""
                cell.lbeDia.text = ""
                cell.lbePul.text = ""
                cell.lbeDate.text = ""
            }
            
            var lineChartEntry = [ChartDataEntry]()
            var lineChartEntry2 = [ChartDataEntry]()
            let lineChartEntry3 = [ChartDataEntry]()
            
            let total = NSMutableArray()
            let total2 = NSMutableArray()
            let monthsB =  NSMutableArray()

            for i in 0..<pulseoximeterArray.count{
                
                var dict1 = NSDictionary ()
                dict1 = pulseoximeterArray.object(at: i) as! NSDictionary
                
                
                var systolicIntVal = Int()
                var diastolicIntVal = Int()

                var dateTime = NSNumber()
                
               
                systolicIntVal = dict1.value(forKey: "spo2") as! Int
                diastolicIntVal = dict1.value(forKey: "pr") as! Int

                
                dateTime = dict1.value(forKey: "datenTime") as! NSNumber
                let timeDouble = Double(dateTime)
                
                let unixTimeStamp: Double = timeDouble / 1000.0
                let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
                
                var dateString = ""
                dateString = dateFormatter.string(from: exactDate)
                print(dateString)
                if i == pulseoximeterArray.count - 1{
                    cell.lbeSy.text = String(systolicIntVal)
                    cell.lbeDia.text = String(diastolicIntVal)
                    cell.lbePul.text = ""
                    cell.lbeDate.text = dateString
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
                
                monthsB.add(monthDate)
                total .add(systolicIntVal)
                total2 .add(diastolicIntVal)

                
                
                
            }
            
            //spo2
            cell.lbeTitalChart.text = "Pulseoximeter"
            for i in 0..<total.count {
                let values = ChartDataEntry(x: Double(i), y: total[i] as! Double)
                
                lineChartEntry.append(values)
                
                
            }
            for i in 0..<total2.count{
                let values2 = ChartDataEntry(x: Double(i) , y: total2[i] as! Double)
                lineChartEntry2.append(values2)
            }
          
            
            let line1 = LineChartDataSet(entries: lineChartEntry,label : "spo2")
            let line2 = LineChartDataSet(entries: lineChartEntry2,label : "pr")
            
            
            
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
            cell.lineChart.data = data
            
            cell.lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:monthsB as! [String])
            cell.lineChart.leftAxis.axisMinimum = 0
            cell.lineChart.leftAxis.axisMaximum = 150
            cell.lineChart.rightAxis.enabled = false
            
            cell.lineChart.xAxis.labelPosition = .bottom
            cell.lineChart.scaleXEnabled = false
            cell.lineChart.scaleYEnabled = false
            cell.lineChart.xAxis.drawGridLinesEnabled = false
            cell.lineChart.leftAxis.drawGridLinesEnabled = true
            
            cell.lineChart.leftAxis.labelCount = 3
            cell.lineChart.xAxis.setLabelCount(2, force: true)
            cell.lineChart.leftAxis.axisLineColor = UIColor.black
            cell.lineChart.xAxis.axisLineColor = UIColor.black
            line1.lineWidth = 4
            line2.lineWidth = 4
            line1.drawValuesEnabled = false
            line2.drawValuesEnabled = false
            
            
            //        chartVw.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
            let legend = cell.lineChart.legend
            legend.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            legend.xEntrySpace = 20
            legend.yEntrySpace = 10
            legend.xOffset = 0
            legend.yOffset = 0
            cell.lineChart.xAxis.avoidFirstLastClippingEnabled = true
            
            
            
        }
       
        
        
        
        
        
        
        return cell
    }
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVw.deselectRow(at: indexPath, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Button Action
    
    @IBAction func btnMenu(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    @IBAction func refreshBtnClicked(_ sender: Any) {
        getBloodpressureApi_Dashboard()
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "logged_in")
        UserDefaults.standard.synchronize()
        if #available(iOS 13.0, *) {
            let login = self.storyboard?.instantiateViewController(identifier: "LoginVc") as? LoginVc
            let del = UIApplication.shared.delegate as? AppDelegate
            del?.window?.rootViewController = login
        } else {
            // Fallback on earlier versions
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as? LoginVc
            let del = UIApplication.shared.delegate as? AppDelegate
            del?.window?.rootViewController = login
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Get Api
    
    func getBloodpressureApi_Dashboard(){
        hud.show(animated: true)
        
        self.allChartArray.removeAllObjects()
        self.bloodPressureArray.removeAllObjects()
        self.weightArray.removeAllObjects()
        self.pulseoximeterArray.removeAllObjects()
        self.glucoseArray.removeAllObjects()
        
         var personID = Int()
         personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        
        var authToken = ""
        authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        var url = ""
        url = BaseUrl
        let headers: [String:Any] = ["X-Auth-Token":authToken]
        
       // http://40.79.35.122:8081/emrmega/api/bloodpressure/alllastreading/1
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/bloodpressure/alllastreading/\(personID)")! as URL,
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
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let array = json  as? NSArray {
                            self.allChartArray.addObjects(from: array as [AnyObject])
                            print(self.allChartArray)

                            
                            for i in 0..<self.allChartArray.count{
                                
                                var dict1 = NSDictionary()
                                dict1 = self.allChartArray[i]  as! NSDictionary
                                
                                var strName = String()
                                strName = dict1.value(forKey: "componetName") as! String
                                if strName  == "bloodpressure"{
                                    var array = dict1.value(forKey: "readings") as! NSArray
                                    array = array.reversed() as NSArray
                                    self.bloodPressureArray.addObjects(from: array as [AnyObject])
                                     print(self.bloodPressureArray)
                                }
                                if strName  == "glucose"{
                                    var array = dict1.value(forKey: "readings") as! NSArray
                                    array = array.reversed() as NSArray

                                    self.glucoseArray.addObjects(from: array as [AnyObject])
                                    print(self.glucoseArray)
                                }
                                
                                if strName  == "pulseoximeter"{
                                    var array = dict1.value(forKey: "readings") as! NSArray
                                    array = array.reversed() as NSArray

                                    self.pulseoximeterArray.addObjects(from: array as [AnyObject])
                                    print(self.pulseoximeterArray)
                                }
                                
                                if strName  == "weight"{
                                    var array = dict1.value(forKey: "readings") as! NSArray
                                    array = array.reversed() as NSArray

                                    self.weightArray.addObjects(from: array as [AnyObject])
                                    print(self.weightArray)
                                }
                                
                                
                            }
                           
                                    DispatchQueue.main.async {
                                        self.tableVw.reloadData()
                                        self.hud.hide(animated: true)
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
    
    
    
    
}
