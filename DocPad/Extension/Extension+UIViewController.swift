//
//  Extension+UIViewController.swift
//

import UIKit
import Reachability
import SVProgressHUD

extension UIViewController {
    
    //MARK: Alert
    func popUpAlert(title: String, message: String, actionInTitles:[String], actionStyles:[UIAlertAction.Style], action: [(UIAlertAction) -> Void]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, title) in actionInTitles.enumerated() {
                let action = UIAlertAction(title: title, style: actionStyles[index], handler: action[index])
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Reachability
    func isReachable() -> Bool {
        do {
            let reacheability = try Reachability.init()
            if reacheability.connection != .unavailable {
                return true
            }
            else {
                self.popUpAlert(title: "No internet connection", message: "Please check your internet connection!", actionInTitles: ["Ok"], actionStyles: [.default], action: [{_ in
                    self.dismiss(animated: true, completion: nil)
                    },])
            }
        } catch let error {
            debugPrint("error occured while check internet connetion = \(error.localizedDescription)")
        }
        return false
    }
    
    //MARK: SVProgressHud
    func showHud(title: String) {
        SVProgressHUD.show(withStatus: title)
    }
    
    func hideHud() {
        SVProgressHUD.dismiss()
    }
}
