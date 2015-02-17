//
//  TerminalViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/16/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class TerminalViewController: UIViewController {

    @IBOutlet weak var commandField: UITextField!
    @IBOutlet weak var terminalOutputView: UITextView!
    
    var ip: String = NSUserDefaults.standardUserDefaults().stringForKey("ip")!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ip = userDefaults.stringForKey("ip")!
    }
    
    override func viewDidAppear(animated: Bool) {
        //upate IP once user switches to Terminal view
        ip = NSUserDefaults.standardUserDefaults().stringForKey("ip")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendCommand(sender: AnyObject) {
        var command = "\(commandField.text.capitalizedString)\n:"
        println("ip:\(ip)\ncommand:\n\(command)")
        
        //send POST request with command
        var request = NSMutableURLRequest(URL: NSURL(string: "http://\(ip)/command")!)
        request.HTTPMethod = "POST"
        
        var requestBodyData: NSData = (command as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        
        request.addValue((String(countElements(command))), forHTTPHeaderField: "Content-Length")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = requestBodyData
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
        println("sending POST request")
        
        connection?.start()
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        println(response)
        
        if let httpResponse = response as? NSHTTPURLResponse {
            println("error \(httpResponse.statusCode)")
        }
    }
}
