//
//  VideoSessionVC.swift
//  DocPad
//
//  Created by Parminder Singh on 01/04/20.
//  Copyright © 2020 DeftDeskSol. All rights reserved.
//

import UIKit
import JitsiMeet

class VideoSessionVC: UIViewController {
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: JitsiMeetView?
    
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    @IBOutlet weak var tblVw: UITableView!
    
    let personId = UserDefaults.standard.value(forKey: "PersonID")
    
    let df = DateFormatter()
    
    var page = 1
    
    var videosSessionArray: [VideoSessionVM] = [] {
        didSet {
            if self.videosSessionArray != oldValue  {
                self.tblVw.reloadData()
            }
        }
        willSet {
            self.videosSessionArray.append(contentsOf: newValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        
        df.dateFormat = "MMM dd, yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        self.fetchDataFromServer()
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func homeBtnClicked(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
    
    //MARK: API Call
    func fetchDataFromServer() {
        if isReachable() {
            self.showHud(title: "")
            let authToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
            let headers: [String:Any] = ["X-Auth-Token":authToken]

            let urlStr = "\(Endpoint.videoSessionApi)\(personId ?? "")?currentPage=\(page)&pageSize=20&sortDirections=desc"
            VideoSessionRequest(serviceManager: ServiceManager()).fetchVideoSessionsFromServer(url: URL(string: urlStr)!, headers: headers) { (modalArray,error)  in
                DispatchQueue.main.async {
                    self.hideHud()
                    if error == nil {
                        self.videosSessionArray = modalArray!
                    }
                    else {
                        self.popUpAlert(title: "Error", message: error!.localizedDescription, actionInTitles: ["Ok"], actionStyles: [.cancel], action: [{_ in
                            self.dismiss(animated: true, completion: nil)
                            },])
                    }
                }
            }
        }
    }
    
    //MARK: ScrollView Delegate Functions
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.videosSessionArray.count > 0{
            if self.videosSessionArray.count == page*20 {
                let rows = self.tblVw.indexPathsForVisibleRows?.map { $0.row } ?? []
                for row in rows {
                    //print(String(format: "%d", section))
                    if row == videosSessionArray.count - 4{
                        self.page = self.page+1
                        self.fetchDataFromServer()
                    }
                }
            }
        }
    }
}

extension VideoSessionVC: JitsiMeetViewDelegate {
    //MARK: JitsiMeet Functions
    func openJitsiMeet(roomID: String) {
        cleanUp()
        
        // create and configure jitsimeet view
        let jitsiMeetVw = JitsiMeetView()
        jitsiMeetVw.delegate = self;
        self.jitsiMeetView = jitsiMeetVw
        let userinfo = JitsiMeetUserInfo(displayName: UserDefaults.standard.value(forKey: "fullName") as? String, andEmail: UserDefaults.standard.value(forKey: "email") as? String, andAvatar: URL(string: UserDefaults.standard.value(forKey: "ImageUrl") as! String))
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.room = roomID
            builder.welcomePageEnabled = false
            builder.userInfo = userinfo
            let strVideo = UserDefaults.standard.value(forKey: "VideoServer") as? String
            if strVideo != "" {
                let urlServer = URL(string: strVideo!)
                builder.serverURL = urlServer
            }
        }
        
        jitsiMeetView?.join(options)
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView!)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)
        
        // animate in
        jitsiMeetView?.alpha = 0
        pipViewCoordinator?.show()
    }
    
    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    
    //MARK: JitsiMeet Delegate Functions
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.hide() { _ in
                self.cleanUp()
            }
        }
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
}

extension VideoSessionVC: UITableViewDataSource, UITableViewDelegate {
    //MARK: TableView DataSource and Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videosSessionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let lblSessionName = cell?.viewWithTag(1) as! UILabel
        let lblCreatedDate = cell?.viewWithTag(3) as! UILabel
        let btnJoin = cell?.viewWithTag(4) as! UIButton
        
        let videoSession = self.videosSessionArray[indexPath.row]
        lblSessionName.text = videoSession.providerName
        
        let date = Date(timeIntervalSince1970:videoSession.creationDate/1000)
        lblCreatedDate.text = df.string(from: date)
        
        btnJoin.addTarget(self, action: #selector(joinVideoSession(sender:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func joinVideoSession(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Coming Soon", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
//        let point = self.tblVw.convert(CGPoint.zero, from: sender)
//
//        guard let indexPath = self.tblVw.indexPathForRow(at: point) else {
//            fatalError("can't find point in tableView")
//        }
//        let videoSession = self.videosSessionArray[indexPath.row]
//        self.openJitsiMeet(roomID: videoSession.roomID)
    }
}
