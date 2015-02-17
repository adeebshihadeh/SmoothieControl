//
//  SettingsViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/16/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ipField: UITextField!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var ip: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ip = userDefaults.stringForKey("ip")!
        ipField.text = "\(ip)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func setIP(sender: AnyObject) {
        var ipAddress: String = ipField.text
        userDefaults.setObject(ipAddress, forKey: "ip")
    }
}
