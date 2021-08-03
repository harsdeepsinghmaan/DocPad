//
//  AppDelegate.swift
//  DocPad
//
//  Created by DeftDeskSol on 02/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import CoreData
import LGSideMenuController
import IQKeyboardManagerSwift
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PulseOximeterDelegate {
    
    

    var window: UIWindow?
    
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!
    let dataArray = NSMutableArray()
    var strSpo: String!
    var strPulse: String!
    
    var timerPulseApiCall: Timer!
    var callApi:Bool!
    var countAPiTime = 0
    var strReadingDate: String!
    let pulse = PulseOximeterClass()
    
    //harsh
    //Harsh@123

//http://40.79.35.122:8081/emrmega/api
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        if UserDefaults.standard.value(forKey: "VideoServer") == nil {
            UserDefaults.standard.set("", forKey: "VideoServer")
            UserDefaults.standard.synchronize()
        }
        
//        UIApplication.shared.statusBarView?.backgroundColor = .white
    
         IQKeyboardManager.shared.enable = true
        
       // centralManager = CBCentralManager(delegate: self, queue: nil)
        
        pulse.delegate = self
        pulse.startMonitoring()
        
        callApi = false
        if #available(iOS 10.0, *) {
            timerPulseApiCall = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.countAPiTime = self.countAPiTime + 1
            })
        } else {
            // Fallback on earlier versions
            timerPulseApiCall = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateApiTimer), userInfo: nil, repeats: true)
        }

        if !UserDefaults.standard.bool(forKey: "CheckUrl"){
            UserDefaults.standard.set(true, forKey: "ViewMoved")
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AccountSettingVc")
            let navigationController = UINavigationController(rootViewController: controller)
            let del = UIApplication.shared.delegate as! AppDelegate
            del.window?.rootViewController = navigationController
        }
        else{
            if !UserDefaults.standard.bool(forKey: "logged_in")
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LoginVc")
                let navigationController = UINavigationController()

                navigationController.pushViewController(controller, animated: true)

            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let leftController = storyboard.instantiateViewController(withIdentifier: "SideMenuController")
                
                let homecontroller = storyboard.instantiateViewController(withIdentifier: "HomeVc")
                let navigationController = UINavigationController(rootViewController: homecontroller)
                
                let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                              leftViewController: leftController,
                                                              rightViewController: nil)
                
                sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width - 70
                sideMenuController.leftViewPresentationStyle = .slideAbove
                
                sideMenuController.rightViewWidth = 100.0
                sideMenuController.leftViewPresentationStyle = .slideAbove
                
                let del = UIApplication.shared.delegate as! AppDelegate
                del.window?.rootViewController = sideMenuController
            }
            
        }
        
        UserDefaults.standard.set(false, forKey: "DelayBool")
        UserDefaults.standard.synchronize()
      
        return true
    }
    
    @objc func updateApiTimer() {
        
        self.countAPiTime = self.countAPiTime + 1
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    
    func pulseOximeterReadingUpdated() {
        var strSpoReading: String!
        var strPulseReading: String!
        if pulse.spO2 != "127" {
            strSpoReading = String(pulse.spO2)
            print(String(format: "SpO2Value----- %@",strSpoReading!))
        }
        if pulse.pulse != "511" {
            strPulseReading = String(pulse.pulse)
            print(String(format: "PulseRateValue----- %@",strPulseReading!))
        }
        
        var delayTime = ""
        if let time = UserDefaults.standard.value(forKey: "DelayTime") as? String {
            delayTime = time
        }
        
        var IntDelayTime = Int()
        
        if delayTime != ""{
            IntDelayTime = Int(delayTime)!
        }
        else{
            IntDelayTime = 20
        }
        
        if strPulseReading != nil && strSpoReading != nil {
            if !callApi {
                strSpo = strSpoReading
                strPulse = strPulseReading
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "reloadCollectionVw")))
                self.callPulseeoximetterRecordApi()
                countAPiTime = 0
                callApi = true
            }
            else if countAPiTime > IntDelayTime {
                strSpo = strSpoReading
                strPulse = strPulseReading
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "reloadCollectionVw")))
                self.callPulseeoximetterRecordApi()
                countAPiTime = 0
            }
        }
    }
}

extension AppDelegate {
    // MARK: Post Pulseeoximetter Api
    func callPulseeoximetterRecordApi() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM d, yyyy, h:mm a" // "MMM d, yyyy, h:mm a"
        let formattedDate = format.string(from: date)
        strReadingDate = formattedDate
        if UserDefaults.standard.value(forKey: "AuthToken") == nil {
            return
        }
        let authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
        
        let headers: [String:Any] = ["X-Auth-Token": authToken,"content-type": "application/json"]
        var postData =  Data()
        
        let personID = UserDefaults.standard.value(forKey: "PersonID") as! Int
        
        let Spo = Int(self.strSpo)
        let Pulse = Int(self.strPulse)
        let strDate = self.strReadingDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a" //"dd MMM yyyy"
        
        let someDate = dateFormatter.date(from: strDate!)
        let timeInterval = Int64(someDate!.timeIntervalSince1970 * 1000.0)
        
        // convert to Integer
        let myInt = timeInterval
        
        let parameters = [
            "patientId": personID,
            "datenTime": myInt,
            "spo2": Spo as Any,
            "pr": Pulse as Any,
            "enteredBy": 1,
            "deviceId": pulse.serialNumber!,
            "bluetoothName": pulse.name] as [String : Any]
        do {
            postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch let error{
            debugPrint("catch error = \(error.localizedDescription)")
        }
        let request = NSMutableURLRequest(url: NSURL(string: "\(BaseUrl )/pulseoximeter")! as URL,
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
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("parse JSON: \(String(describing: jsonStr))")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "fetchPulseOximeterData")))
                            }
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
