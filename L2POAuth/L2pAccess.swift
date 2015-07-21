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


func getUserToken(user:UserCodeReturn) -> UserToken {
    let response = Just.post(tokenURL, data: ["client_id":clientID, "code":user.device_code, "grant_type":"device"])
    if let statuscode = response.statusCode as Int! {
        if statuscode != 200 {
            println("error:  \(statuscode)")
            return UserToken(status: "error:  \(statuscode)")
        }
    }
    if let json = response.json as? NSDictionary {
        if let status = json["status"] as? String {
            if status != "ok" {
                println(status)
                return UserToken(status: status)
            }
            if let access_token = json["access_token"] as? String {
                if let refresh_token = json["refresh_token"] as? String {
                    if let expires_in = json["expires_in"] as? Int {
                        return UserToken(access_token: access_token, refresh_token: refresh_token, expires: expires_in)
                    }
                }
            }
            
        }
    }
    return UserToken(status: "error")
}

func refreshToken(userToken:UserToken) {
    let response = Just.post(tokenURL, data: ["client_id":clientID, "refresh_token":userToken.refresh_token, "grant_type":"refresh_token"])
    if let statuscode = response.statusCode as Int! {
        if statuscode != 200 {
           println("error:  \(statuscode)")
        }
    }
    if let json = response.json as? NSDictionary {
        if let error = json["status"] as? String {
            println("error:  \(error)")
        } else {
            if let access_token = json["access_token"] as? String {
                if let expires_in = json["expires_in"] as? Int {
                        userToken.access_token = access_token
                        userToken.expires_in = expires_in
                    
                }
            }
        }
    }
    
}




func invalidateToken(userToken:UserToken){
    let response = Just.post(tokenURL, data: ["client_id":clientID, "refresh_token":userToken.refresh_token, "grant_type":"invalidate"])
    if let statuscode = response.statusCode as Int! {
        if statuscode != 200 {
            println("error:  \(statuscode)")
        }
    }
    
}

func tokenIsValid(userToken:UserToken) -> Bool{
    let response = Just.post(tokenInfoURL, data: ["client_id":clientID, "access_token":userToken.access_token])
    if let statuscode = response.statusCode as Int! {
        if statuscode != 200 {
            println("error:  \(statuscode)")
            return false
        }
    }
    if let json = response.json as? NSDictionary {
        if let state = json["state"] as? String {
            if state == "valid" {
                return true
            }
            
        }
    }
    
    return false

    
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

class UserToken {
    var access_token:String
    var refresh_token:String
    var expires_in:Int
    var status:String
    
    init(access_token:String,refresh_token:String,expires:Int){
        self.access_token = access_token
        self.refresh_token = refresh_token
        expires_in = expires
        status = "ok"
    }
    
    
    
    init(status:String){
        access_token = ""
        refresh_token = ""
        expires_in = 0
        self.status = status
    }
}






