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
    
    var userCodeReturn:UserCodeReturn!
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
            userCodeReturn = obtainUserCode()
        
            //accessing fields
            println("device code: " + userCodeReturn.device_code)
            println("user code: " + userCodeReturn.user_code)
            println("url: " + userCodeReturn.verification_url)
            println("expires in: \(userCodeReturn.expires_in)")
      
        
        
        
    }
    
    
    @IBAction func authUserClicked() {
        println("request OAuth Token with device code: " + userCodeReturn.device_code)
        userToken = getUserToken(userCodeReturn)
        println("")
        println("access Token: " + userToken.access_token)
        println("status: " + userToken.status)
        println("expires in: \(userToken.expires_in)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

