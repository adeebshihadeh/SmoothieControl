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
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var terminalOutput: NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendCommand(sender: AnyObject) {
        //update ip address
        if let ipAddress: AnyObject = userDefaults.objectForKey("ip") {
            println(ipAddress)
            
            var ip: AnyObject = ipAddress
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
        }else {
            let alert = UIAlertView()
            alert.title = "Set IP address"
            alert.message = "An IP address must be set so SmoothieControl knows where to send your command."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {

        println(response)
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        terminalOutput = NSString(data: data, encoding: NSUTF8StringEncoding)!
        println(terminalOutput)
        terminalOutputView.text = "\(terminalOutputView.text)\n\(terminalOutput)"
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
