//
//  VitalsVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import CoreBluetooth



var instanceOfCustomObject: ANDDevice = ANDDevice()

class VitalsVc: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource,ANDDeviceDelegate, UHNBGMControllerDelegate{
    
    
    var weightTimer: Timer!
    var bpTimer: Timer!
    var glucoseDeviceName: String!
    var glucoseDeviceID: String!
    var weightName: String!
    var bpName: String!
    var serialNumberGlucose: String!
    var serialNumberBP: String!
    var serialNumberWeight: String!

    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    var viewHasMovedToRight = Bool()
    var itemNameArray = ["Blood Pressure","Glucose","Pulseoximetry","Weight","Cholestrol","Body Dimension","Body Composition","Height","Peak Flow"]
    var itemImageArray = [#imageLiteral(resourceName: "cholestrol"),#imageLiteral(resourceName: "glucose"),#imageLiteral(resourceName: "pulseoximeter"),#imageLiteral(resourceName: "weight_Img"),#imageLiteral(resourceName: "bloodPressure_Img"),#imageLiteral(resourceName: "bodyDimension_Img"),#imageLiteral(resourceName: "bodyComposition_Img"),#imageLiteral(resourceName: "height_Img"),#imageLiteral(resourceName: "peakFlow_Img")]
    
    
    var strSystolic: String!
    var strDiastolic: String!
    var strPulse: String!
    var strReadingDate: String!
    var type = String()
    
    var strDateAndTime: String!
    var strWeight = "0"
    var strUnit = "kg"
    
    var bgmController: UHNBGMController!
    var strMeasurementType: String!
    var strMeasurement: String!
    var strMeasurementContext: String!
    var bgReadings = NSMutableArray()
    var currentBgReadingIndex = Int()
    
    let del = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBgReadingIndex = 0
        
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
            btnBackOutlet.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }
        // Do any additional setup after loading the view.
        
    //    instanceOfCustomObject = ANDDevice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionVw), name:  Notification.Name(rawValue: "reloadCollectionVw"), object: nil)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        instanceOfCustomObject.controlSetup()
        instanceOfCustomObject.delegate = self
        
        if ((instanceOfCustomObject.activePeripheral) != nil) {
            instanceOfCustomObject.peripherials = nil;
        }
        
        instanceOfCustomObject.findBLEPeripherals()
        bgmController = UHNBGMController(delegate: self)
        
        
        strWeight = "0"
        strMeasurement = nil
        strDiastolic = nil
//        strSpo = nil
        strSystolic = nil
        strPulse = nil
    
        collectionVw.reloadData()
        if UserDefaults.standard.value(forKey: "serialNumberGlucose") != nil {
            self.serialNumberGlucose = UserDefaults.standard.value(forKey: "serialNumberGlucose") as! String
        }
        
        if UserDefaults.standard.value(forKey: "serialNumberBP") != nil {
            self.serialNumberBP = UserDefaults.standard.value(forKey: "serialNumberBP") as! String
        }
        
        if UserDefaults.standard.value(forKey: "serialNumberWeight") != nil {
            self.serialNumberWeight = UserDefaults.standard.value(forKey: "serialNumberWeight") as! String
        }
        
        if #available(iOS 10.0, *) {
            bpTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { (timernew) in
                instanceOfCustomObject = ANDDevice()
                instanceOfCustomObject.controlSetup()
                instanceOfCustomObject.delegate = self
                
                if ((instanceOfCustomObject.activePeripheral) != nil) {
                    instanceOfCustomObject.activePeripheral = nil;
                }
                instanceOfCustomObject.findBLEPeripherals()
            })
        } else {
            // Fallback on earlier versions
            bpTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(resetBluetooth), userInfo: nil, repeats: false)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        timerPulseApiCall.invalidate()
//        callApi = false
        del.strSpo = nil
        del.strPulse = nil
    }
    
    @objc func reloadCollectionVw() {
        self.collectionVw.reloadData()
    }
    
    // MARK:- BloodPresure and Weight Delegate Functions
    func gotDevice(_ peripheral: CBPeripheral!) {
        if bpTimer != nil {
            bpTimer.invalidate()
        }
        if weightTimer != nil {
            weightTimer.invalidate()
        }
        
        if (peripheral.name != nil) {
            if ((peripheral.name?.contains("A&D_UC-352BLE"))!) {
                self.type = "ws"
                self.weightName = peripheral.name
                instanceOfCustomObject.connect(peripheral)
            }
            else {
                self.type = "bp"
                self.bpName = peripheral.name
                instanceOfCustomObject.connect(peripheral)
            }
        }
        
    }
    
    func deviceReady() {
        
        if (self.type == "bp") {
            let ad : ADBloodPressure = ADBloodPressure.init(device: instanceOfCustomObject )
            ad.setTime()
            ad.readMeasurement()
        }
         if (self.type == "ws") {
            let ad : ADWeightScale = ADWeightScale.init(device: instanceOfCustomObject )
            ad.setTime()
            ad.readMeasurement()
        }
        
    }
    

    func gotBloodPressure(_ data: [AnyHashable : Any]!) {
        print(data)
        var systolicInt = Int()
        var diastolicInt = Int()
        var pulseInt = Int()
        var date = NSDate()
        
        
        systolicInt = Int(data["systolic"] as! Int)
        diastolicInt = Int(data["diastolic"] as! Int)
        pulseInt = Int(data["pulse"] as! Int)
        date = data["time"] as! NSDate
        
        self.strSystolic = String(systolicInt)
        self.strDiastolic = String(diastolicInt)
        self.strPulse = String(pulseInt)
        self.serialNumberBP = data["serialNumber"] as? String
        
        if bpTimer != nil {
            bpTimer.invalidate()
        }
        
        if #available(iOS 10.0, *) {
            bpTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timernew) in
                instanceOfCustomObject = ANDDevice()
                instanceOfCustomObject.controlSetup()
                instanceOfCustomObject.delegate = self
                
                if ((instanceOfCustomObject.activePeripheral) != nil) {
                    instanceOfCustomObject.activePeripheral = nil;
                }
                instanceOfCustomObject.findBLEPeripherals()
            })
        } else {
            // Fallback on earlier versions
            bpTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(resetBluetooth), userInfo: nil, repeats: true)
        }
        
        if self.strSystolic != "2047" {
            self.call_bloodPreasureApi(date: date)
        }
    }
    
    func gotWeight(_ data: [AnyHashable : Any]!) {
        print(data)
        var weightDouble = Double()
        var weightUnit = String()
        var date = NSDate()
        
        weightUnit = data["unit"] as! String
        if weightUnit == "kg"{
            weightDouble = data["weight"] as! Double
            let weightFloat = Float(weightDouble/10)
            strWeight = String(format:"%0.1f", weightFloat)
            strUnit = "kg"
        }
        else{
            weightDouble = data["weight"] as! Double
            let weightFloat = Float(weightDouble/10)
            //strWeight = String(format: "%0.1f",weightFloat*0.45359237)
            strWeight = String(format: "%0.1f",weightFloat)
            strUnit = "lbs"
        }
        
        date = data["time"] as! NSDate
        self.serialNumberWeight = data["serialNumber"] as? String
        if weightTimer != nil {
            weightTimer.invalidate()
        }
        
        if #available(iOS 10.0, *) {
            weightTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timernew) in
                instanceOfCustomObject = ANDDevice()
                instanceOfCustomObject.controlSetup()
                instanceOfCustomObject.delegate = self
                
                if ((instanceOfCustomObject.activePeripheral) != nil) {
                    instanceOfCustomObject.activePeripheral = nil;
                }
                instanceOfCustomObject.findBLEPeripherals()
            })
        } else {
            // Fallback on earlier versions
            weightTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(resetBluetooth), userInfo: nil, repeats: true)
        }
        
        self.callWeightRecordApi(date: date)
        self.collectionVw.reloadData()
    }
    
    
    func gotSerialNumberWeight(_ serialNumber: String!) {
        if bpTimer != nil {
            bpTimer.invalidate()
        }
        if weightTimer != nil {
            weightTimer.invalidate()
        }
        if #available(iOS 10.0, *) {
            bpTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { (timernew) in
                instanceOfCustomObject = ANDDevice()
                instanceOfCustomObject.controlSetup()
                instanceOfCustomObject.delegate = self
                
                if ((instanceOfCustomObject.activePeripheral) != nil) {
                    instanceOfCustomObject.activePeripheral = nil;
                }
                instanceOfCustomObject.findBLEPeripherals()
            })
        } else {
            // Fallback on earlier versions
            bpTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(resetBluetooth), userInfo: nil, repeats: false)
        }
    }
    
    @objc func resetBluetooth() {
        instanceOfCustomObject = ANDDevice()
        instanceOfCustomObject.controlSetup()
        instanceOfCustomObject.delegate = self
        if ((instanceOfCustomObject.activePeripheral) != nil) {
            instanceOfCustomObject.activePeripheral = nil;
        }
        instanceOfCustomObject.findBLEPeripherals()
    }
    
    
    //MARK:- UHNBGMControllerDelegate
    func bgmController(_ controller: UHNBGMController!, didDiscoverGlucoseMeterWithName bgmDeviceName: String!, services serviceUUIDs: [Any]!, rssi RSSI: NSNumber!) {
        self.glucoseDeviceName = bgmDeviceName
        print("Glucose:", bgmDeviceName)
        bgmController!.connect(toDevice: bgmDeviceName)
    }
    
    
    func bgmController(_ controller: UHNBGMController!, didConnectToGlucoseMeterWithName bgmDeviceName: String!, withIdentifier deviceIdentifier: String!) {
        self.glucoseDeviceName = bgmDeviceName
        self.glucoseDeviceID = deviceIdentifier
        bgmController!.getGlucoseFeatures()
    }
    
    func bgmController(_ controller: UHNBGMController!, didDisconnectFromGlucoseMeter bgmDeviceName: String!) {
    }
    
    func bgmController(_ controller: UHNBGMController!, didGetNumberOfRecords numberOfRecords: NSNumber!) {
        bgmController.getAllStoredRecords()
        if UserDefaults.standard.integer(forKey: "sequenceNumber") == 0 || UserDefaults.standard.integer(forKey: "sequenceNumber") > 65535 {
            UserDefaults.standard.set(1, forKey: "sequenceNumber")
            UserDefaults.standard.synchronize()
        }
        bgmController.getNumberOfRecordsGreaterThan(Int32(UserDefaults.standard.integer(forKey: "sequenceNumber")))
    }
    
    
    func bgmControllerDidGetSupportedFeatures(_ controller: UHNBGMController!) {
        self.bgmController.enableAllNotifications(true)
        self.bgmController.enableNotificationGlucoseMeasurement(true)
    }
    
    func bgmController(_ controller: UHNBGMController!, didSetNotificationStateForAllNotifications enabled: Bool) {
        bgmController.getNumberOfStoredRecords()
    }
    
    
    func bgmController(_ controller: UHNBGMController!, didGetGlucoseMeasurementAt index: UInt, withDetails measurementDetails: [AnyHashable : Any]!) {
        bgReadings.add(measurementDetails)
        currentBgReadingIndex = bgReadings.count - 1
       // ShowData()
    }
    
    func bgmController(_ controller: UHNBGMController!, didGetGlucoseMeasurementContextAt index: UInt, withDetails measurementContextDetails: [AnyHashable : Any]!) {
        var glucoseReadingDetails = bgReadings[currentBgReadingIndex] as? [AnyHashable : Any]
        var value: NSNumber? = nil
        
        // insert the carbohydrate ID (ie. reading context)
        if nil != (value = measurementContextDetails[kGlucoseMeasurementContextKeyCarbohydrateID] as? NSNumber) {
            glucoseReadingDetails![kGlucoseMeasurementContextKeyCarbohydrateID] = value
        }
        
//        // insert the meal (ie. pre/post)
//        if nil != (value = measurementContextDetails[kGlucoseMeasurementContextKeyMeal] as? NSNumber) {
//            glucoseReadingDetails![kGlucoseMeasurementContextKeyMeal] = value
//        }
        
        // NOTE: If you want to insert more information, find it here.
        
        if !bgReadings.contains(glucoseReadingDetails) {
            bgReadings.insert(glucoseReadingDetails as Any, at: currentBgReadingIndex)
        }
        if self.serialNumberGlucose != nil {
            ShowData()
        }
        
        
        
    }
    
    func bgmController(_ controller: UHNBGMController!, didGetSerialNumber serialNumber: String!) {
        self.serialNumberGlucose = serialNumber
        UserDefaults.standard.setValue(self.serialNumberGlucose, forKey: "serialNumberGlucose")
        UserDefaults.standard.synchronize()
    }
    
    func bgmController(_ controller: UHNBGMController!, didCompleteTransferWithNumberOfRecords numberOfRecords: UInt) {
        self.currentBgReadingIndex = 0;
    }
    
    func ShowData(){
        print(bgReadings)
        
        
        
        var bgReadingDetails = bgReadings[bgReadings.count - 1] as? [AnyHashable : Any]
        var value = bgReadingDetails?[kGlucoseMeasurementKeyGlucoseConcentration] as? NSNumber
        let measurmentType  = bgReadingDetails?[kGlucoseMeasurementKeyType] as? NSNumber
        let unitsNumber = bgReadingDetails?[kGlucoseMeasurementKeyGlucoseConcentrationUnits] as? NSNumber
        
        //
        let units = GlucoseMeasurementGlucoseConcentrationUnits(rawValue: (unitsNumber?.uintValue)!)
        
        
        // convert the value into standard units
        
        let glucoseDate  = bgReadingDetails?[kGlucoseMeasurementKeyCreationDate] as? NSDate
        
        
        
        if  3 != Int(units!.rawValue) {
            value = value!.convertGlucoseConcentration(from: units!, to: GlucoseMeasurementGlucoseConcentrationUnits(rawValue: 2)!)
        }
        let context = bgReadingDetails![kGlucoseMeasurementContextKeyCarbohydrateID] as? NSNumber
        var contextString = String()
        if nil != context {
            // set the context string
            if UInt(1) == context!.uintValue {
                contextString = NSLocalizedString("Breakfast ", comment: "")
            } else if UInt(2) == context!.uintValue {
                contextString = NSLocalizedString("Lunch ", comment: "")
            } else if UInt(3) == context!.uintValue {
                contextString = NSLocalizedString("Dinner ", comment: "")
            } else if UInt(4) == context!.uintValue {
                contextString = NSLocalizedString("Snack ", comment: "")
            } else if UInt(5) == context!.uintValue {
                contextString = NSLocalizedString("Drink ", comment: "")
            } else if UInt(6) == context!.uintValue {
                
                contextString = NSLocalizedString("Supper ", comment: "")
            }
        }
        
        switch measurmentType {
        case 0:
            self.strMeasurementType = ""
        case 1:
            self.strMeasurementType = "Capillary Whole blood"
        case 2:
            self.strMeasurementType = "Capillary Plasma"
        case 3:
            self.strMeasurementType = "Venous Whole blood"
        case 4:
            self.strMeasurementType = "Venous Plasma"
        case 5:
            self.strMeasurementType = "Arterial Whole blood"
        case 6:
            self.strMeasurementType = "Arterial Plasma"
        case 7:
            self.strMeasurementType = "Undetermined Whole blood"
        case 8:
            self.strMeasurementType = "Undetermined Plasma"
        case 9:
            self.strMeasurementType = "Interstitial Fluid (ISF)"
        case 10:
            self.strMeasurementType = "Control Solution"
        case 11:
            self.strMeasurementType = ""
        default:
            self.strMeasurementType = ""
        }
        
        
        strReadingDate = formatDateForDisplay(date: glucoseDate! as Date)
        
        print(value?.doubleValue as Any)
        var GlucoseMEasurementDouble = Double()
        GlucoseMEasurementDouble = Double(value!)
        var FinalValue = Double(GlucoseMEasurementDouble)
        self.strMeasurement = String(format: "%0.0f", FinalValue)
        self.strMeasurementContext = contextString
        
        var sequenceNumber = bgReadingDetails?[kGlucoseMeasurementKeySequenceNumber] as? NSNumber
        sequenceNumber = Int(truncating: sequenceNumber!) + 1 as NSNumber
        if sequenceNumber!.intValue > UserDefaults.standard.integer(forKey: "sequenceNumber") {
            UserDefaults.standard.set(sequenceNumber?.intValue, forKey: "sequenceNumber")
            UserDefaults.standard.synchronize()
            self.callGlucoseRecordApi()
        }
        
    }
    
    // MARK: - Collection View Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return itemNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalCell", for: indexPath) as! VitalsCvc
        cell.itemName.text = itemNameArray[indexPath.row]
        cell.itemVw.image = itemImageArray[indexPath.row]
        
        if indexPath.item == 0 {
            if strSystolic != nil && strDiastolic != nil && strPulse != nil {
                cell.lblValue.text = String(format:"%@/%@/%@",strSystolic,strDiastolic,strPulse)
            }
            else {
                cell.lblValue.text = ""
            }

        } else if indexPath.item == 1 {
            if strMeasurement != nil {
                cell.lblValue.text = strMeasurement
            }
            else {
                cell.lblValue.text = ""
            }

        }
        else if indexPath.item == 2 {
            if del.strSpo != nil && del.strPulse != nil {
                cell.lblValue.text = String(format:"%@/%@",del.strSpo,del.strPulse)
            }
            else {
                cell.lblValue.text = ""
            }

        }
        
        else if indexPath.item == 3 {
            if strWeight != "0" {
                cell.lblValue.text = strWeight
            }
            else {
                cell.lblValue.text = ""
            }
        }
        else {
            cell.lblValue.text = "";
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ((indexPath.row == 0) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "BloodPressureVC") as! BloodPressureVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 1) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "GlucoseVC") as! GlucoseVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 2) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "PulseeoximetryVc") as! PulseeoximetryVc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 3) && (indexPath.section == 0)){
            let controller = storyboard?.instantiateViewController(withIdentifier: "WeightVC") as! WeightVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 4) && (indexPath.section == 0)){
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "CholestrolVC") as! CholestrolVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 5) && (indexPath.section == 0)){
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "BodyDimensionVC") as! BodyDimensionVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 6) && (indexPath.section == 0)){
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "BodyCompositionVC") as! BodyCompositionVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 7) && (indexPath.section == 0)){
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "HeightVC") as! HeightVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ((indexPath.row == 8) && (indexPath.section == 0)){
            let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
//            let controller = storyboard?.instantiateViewController(withIdentifier: "PeekFlowVC") as! PeekFlowVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        

    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //          let padding: CGFloat =  48
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if (screenWidth == 320){
            let cellSize = CGSize(width: ((self.view.frame.size.width/3) - 20), height: 145)
            return cellSize
        }
        else{
            let cellSize = CGSize(width: ((self.view.frame.size.width/3) - 20), height: 161)
            return cellSize
        }
        
    }
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0.0
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if ((screenWidth == 375) && (screenHeight == 667)){
            return 40.0
        }
        else if ((screenWidth == 414)  && (screenHeight == 736)) {
            return 60.0
            
        }
            
        else if screenWidth == 375{
            return 80.0
        }
        else if (screenWidth == 414 ){
            return 120.0
        }
        else if (screenWidth == 320){
            return 20.0
        }
        else{
            return 40.0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if ((screenWidth == 375) && (screenHeight == 667)) {
            return UIEdgeInsets(top: 20,left: 10,bottom: 20,right: 10 )
        }
        else if ((screenWidth == 414)  && (screenHeight == 736)) {
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 ) //top, left, bottom, right
        }
        else  if screenWidth == 375{
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 ) //top, left, bottom, right
        }
        else if (screenWidth == 414 ){
            return UIEdgeInsets(top: 40,left: 10,bottom: 40,right: 10 )
        }
        else if (screenWidth == 320){
            return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10 )
        }
        else{
            return UIEdgeInsets(top: 20,left: 10,bottom: 20,right: 10 ) //top, left, bottom, right
        }
        
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
    
    
    @IBAction func btnHome(_ sender: Any) {
        if viewHasMovedToRight == true{
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    // Formats the date chosen with the date picker.
    
    func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: date)
    }
    
}



extension VitalsVc {
    // MARK: POST Glucose Api
    func callGlucoseRecordApi()
    {
        self.collectionVw.reloadData()
       // hud.show(animated: true)
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
//        let formattedDate = format.string(from: date)
//        strReadingDate = formattedDate
        
        var authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        let personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        let source = UserDefaults.standard.value(forKey: "fullName") as! String
        
        let strDate = self.strReadingDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
        
        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
        
        // convert to Integer
        let myInt = timeInterval
        let Measurement = Int(self.strMeasurement)
        let MeasurementContext = String(self.strMeasurementContext)
        let MeasurementType = String(self.strMeasurementType)
        let Note = ""
        
        
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
            "deviceId": self.serialNumberGlucose ?? "",
            "bluetoothName": self.glucoseDeviceName// imp
            
            ] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(BaseUrl ?? "")/glucose")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
//                DispatchQueue.main.async {
//                    self.hud.hide(animated: true)
//                }
            } else {
                
                if(response != nil && data != nil ) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        {
//                            DispatchQueue.main.async {
//                                self.hud.hide(animated: true)
//
//                                var dict = NSDictionary()
//                                dict = json as NSDictionary
//                                print(dict)
//                            }
                        }
                            
                        else {
//                            DispatchQueue.main.async {
//                                self.hud.hide(animated: true)
//                            }
                            
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")
                            DispatchQueue.main.async {
//                                self.hud.hide(animated: true)
//                                let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
//                                let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
//                                alert.addAction(ok)
//                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch let parseError {
//                        DispatchQueue.main.async {
//                            self.hud.hide(animated: true)
//                        }
                        
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
//                        DispatchQueue.main.async {
//                            self.hud.hide(animated: true)
//                            let alert = UIAlertController.init(title: "Oops", message:jsonStr as! String, preferredStyle: .alert)
//                            let ok  = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
//                            alert.addAction(ok)
//                            self.present(alert, animated: true, completion: nil)
//                        }
                    }
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    
    // MARK: POST Weight Api
    func callWeightRecordApi(date: NSDate) {
        self.collectionVw.reloadData()
        let format = DateFormatter()
        format.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
        let formattedDate = format.string(from: date as Date)
        strReadingDate = formattedDate
        
        let authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        let personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        let source = UserDefaults.standard.value(forKey: "fullName") as! String
        
        
        let strDate = self.strReadingDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
        
        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
        
        // convert to Integer
        let myInt = timeInterval
        
        let Weight = Float(self.strWeight)
        let Note = ""
        
        let parameters = [
            "weight": Weight as Any,
            "datenTime": myInt,
            "note": Note,
            "personID": personID,
            "enteredBy": 1,
            "visitdate": "",
            "source": source,
            "deviceId": self.serialNumberWeight ?? "",
            "bluetoothName": self.weightName,
            "unit": strUnit ?? ""
            ] as [String : Any]
        print(parameters)
       
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(BaseUrl ?? "")/weight")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                if(response != nil && data != nil ) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        {
                        }
                            
                        else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")

                        }
                    } catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                    }
                }

            }
        })
        
        dataTask.resume()
        
    }
    
    // MARK: Post Blood Preasure Api
    func call_bloodPreasureApi(date: NSDate) {
        self.collectionVw.reloadData()
        let format = DateFormatter()
        format.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
        let formattedDate = format.string(from: date as Date)
        strReadingDate = formattedDate
        
        let authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        let headers = [
            "x-auth-token": authToken,
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "9e6aacf6-dcef-6630-b810-938cf8d72026"
        ]
        var postData =  Data()
        
        let personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        let source = UserDefaults.standard.value(forKey: "fullName") as! String
        
        let strDate = self.strReadingDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
        
        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
        
        // convert to Integer
        let myInt = timeInterval
        let Systolic = Int(self.strSystolic)
        let Diastolic = Int(self.strDiastolic)
        let Pulse = Int(self.strPulse)
        let Note = ""
        
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
            "deviceId": self.serialNumberBP ?? "",
            "bluetoothName": self.bpName,
            
            ] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(BaseUrl ?? "")/bloodpressure")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.allHTTPHeaderFields = headers as? [String : String]
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {

            } else {
                if(response != nil && data != nil ) {
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        {

                        }
                            
                        else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")

                        }
                    } catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")

                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    
}
