//
//  Api.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/06/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

// MARK: Url

//"http://40.79.35.122:8081/emrmega/api"


let del = UIApplication.shared.delegate as! AppDelegate
let window = del.window

var BaseUrl = UserDefaults.standard.value(forKey: "URL") as! String


let loginApi = "authenticate"
let createProfileApi = "createuserprofile"
let validateloginidApi = "validateloginid?loginid"

struct Endpoint {
    static let videoSessionApi = "\(BaseUrl)/jitsisessions/userpagination/"
    static let dashBoardApi = "\(BaseUrl)/bloodpressure/alllastreading/"
}

struct ServiceManager {
    
    func getApiData<T:Decodable>(requestUrl: URL, headers: [String: Any], resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: Error?) -> Void) {
        var request = URLRequest(url: requestUrl ,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String]
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            if error == nil && responseData != nil && responseData?.count != nil {
                print(String(data: responseData!, encoding: .utf8)!)
                let decoder = JSONDecoder()
                do {
                    
                    let json =  try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    print(json)
                   let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result, error)
                } catch let error {
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                    _=completionHandler(nil, error)
                }
            }
            else {
                debugPrint("API error = \(error?.localizedDescription ?? "")")
                _=completionHandler(nil, error)
            }
        }.resume()
    }
    
    func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: Error?) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, urlResponse, error) in
            if error == nil && responseData != nil && responseData?.count != nil {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result, nil)
                } catch let error {
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                    _=completionHandler(nil, error)
                }
            }
            else {
                debugPrint("Api error = \(error?.localizedDescription ?? "")")
                 _=completionHandler(nil, error)
            }
        }.resume()
    }

}
