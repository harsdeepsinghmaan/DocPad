//
//  VideoSessionVM.swift
//  DocPad
//
//  Created by Parminder Singh on 05/04/20.
//  Copyright © 2020 DeftDeskSol. All rights reserved.
//

import UIKit

struct VideoSessionVM: Equatable {
    let id: Int
    let creationDate: Double
    let sessionName, roomID, createdbyName, providerName: String
}

struct VideoSessionRequest {
    
    private var serviceManager: ServiceManager
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
    }
    
    func fetchVideoSessionsFromServer(url: URL, headers: [String: Any], completionHandler: @escaping([VideoSessionVM]?, Error?) -> Void) {
        serviceManager.getApiData(requestUrl: url, headers: headers, resultType: VideoSessionModal.self) { (response, error)  in
            DispatchQueue.main.async {
                if error == nil {
                    let videoSessions = response!.list.map({ model in
                        return model
                    })
                    let videosSessionArray = videoSessions.map({
                        return VideoSessionVM(id: $0.id, creationDate: $0.creationDate ?? 0, sessionName: $0.sessionName ?? " ", roomID: $0.roomID ?? " ", createdbyName: $0.createdbyName ?? " ", providerName: $0.providerName ?? "")
                    })
                    completionHandler(videosSessionArray, nil)
                }
                else {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
