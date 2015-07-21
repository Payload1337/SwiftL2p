//
//  ViewController.swift
//  L2POAuth
//
//  Created by Philipp Kuinke on 20.07.15.
//  Copyright (c) 2015 Philipp Kuinke. All rights reserved.
//

import UIKit
import Just

class ViewController: UIViewController {
    
    var userCode:UserCodeReturn!
    var userToken:UserToken!
    
    @IBOutlet weak var testButton: UIButton!

    @IBOutlet weak var authUser: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func testButtonClicked() {
            println("request userCode")
            //obtain userCode
            userCode = obtainUserCode()
        
            //accessing fields
            println("device code: " + userCode.device_code)
            println("user code: " + userCode.user_code)
            println("url: " + userCode.verification_url)
            println("expires in: \(userCode.expires_in)")
      
        
        
        
    }
    
    
    @IBAction func authUserClicked() {
        println("request OAuth Token with device code: " + userCode.device_code)
        userToken = getUserToken(userCode)
        println("")
        println("access Token: " + userToken.access_token)
        println("status: " + userToken.status)
        println("expires in: \(userCode.expires_in)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

