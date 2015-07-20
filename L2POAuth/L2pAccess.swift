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
    
    func obtainUserCode() -> UserCodeReturn {
        let response = Just.post(obtainURL, data: ["client_id":clientID, "scope":"l2p.rwth userinfo.rwth"])
        if let json = response.json as? NSDictionary {
            if let url = json["verification_url"] as? String {
                if let user_code = json["user_code"] as? String {
                    if let device_code = json["device_code"] as? String {
                        if let expires_in =  json["expires_in"] as? Int {
                            if let interval = json["interval"] as? Int {
                                return UserCodeReturn(device_code: device_code, user_code: user_code, verification_url: url, expires: expires_in, interval: interval)
                            }
                        }
                    }
                }
            }
        }
        return UserCodeReturn()
    }










struct UserCodeReturn {
    var device_code:String
    var user_code:String
    var verification_url:String
    var expires_in:Int
    var interval:Int
    var error:Bool
    
    init(device_code:String,user_code:String,verification_url:String,expires:Int,interval:Int){
        self.device_code = device_code
        self.user_code = user_code
        self.verification_url = verification_url + "?q=verify&d=" + user_code
        expires_in = expires
        self.interval = interval
        error = false
    }
    
    
    
    init(){
        device_code = ""
        user_code = ""
        verification_url = ""
        expires_in = 0
        interval = 0
        error = true
    }
}






