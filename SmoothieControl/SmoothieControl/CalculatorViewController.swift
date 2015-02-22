//
//  CalculatorViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/22/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load PrusaPrinters calculator
        let request = NSURLRequest(URL: NSURL(string: "http://prusaprinters.org/calculator/#stepspermmbelt")!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
