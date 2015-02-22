//
//  Smoothie.swift
//  SmoothieControl
//
//  Created by quillford on 2/22/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit
import Foundation

var userDefaults = NSUserDefaults.standardUserDefaults()

class Smoothie{
    class func sendCommand(cmd: String){
        if let ipAddress: AnyObject = userDefaults.objectForKey("ip") {
            var ip = userDefaults.stringForKey("ip")!
            
            var command = "\(cmd)\n:"
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
}