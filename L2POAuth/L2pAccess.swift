//
//  L2pAccess.swift
//  L2POAuth
//
//  Created by Philipp Kuinke on 20.07.15.
//  Copyright (c) 2015 Philipp Kuinke. All rights reserved.
//

import Foundation
import Just


    var clientID = "Se8Uit5Hd244cltskaVUpHFVXaZ6exvKVTKsKhKTH70yTlPlWoHHUR5RFsy30nV.app.rwth-aachen.de"
    let obtainURL = "https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/code"
    let tokenURL = "https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/token"
    let tokenInfoURL = "https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/tokeninfo"
    
    func setCliendID(clientId:String){
        clientID = clientId
    }
    
    func obtainUserCode() -> String {
        let response = Just.post(obtainURL, data: ["client_id":clientID, "scope":"l2p.rwth userinfo.rwth"])
        if let json = response.json as? NSDictionary {
            if let url = json["verification_url"] as? String {
                if let user_code = json["user_code"] as? String {
                    return url + "?q=verify&d=" + user_code
                }
            }
        }
        return "null"
    }
