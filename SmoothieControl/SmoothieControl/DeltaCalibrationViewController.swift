//
//  DeltaCalibrationViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/22/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class DeltaCalibrationViewController: UIViewController {

    @IBOutlet weak var stepsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func `continue`(sender: AnyObject) {
        let steps = stepsField.text.toInt()
        Smoothie.sendCommand("M92 X\(steps) Y\(steps) Z\(steps)")
        Smoothie.sendCommand("M500")
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
