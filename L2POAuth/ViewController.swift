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
    
    
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func click(sender: UIButton) {
        //obtain userCode
        let response = obtainUserCode()
        
        //accessing fields
        println(response.device_code)
        println(response.user_code)
        println(response.verification_url)
        println(response.expires_in)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

