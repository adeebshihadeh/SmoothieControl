//
//  ControlViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/18/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {

    @IBOutlet weak var jogIncrementSegment: UISegmentedControl!
    @IBOutlet weak var extruderTempField: UITextField!
    @IBOutlet weak var bedTempField: UITextField!
    @IBOutlet weak var tempOutputField: UILabel!
    @IBOutlet weak var xyFeedrateField: UITextField!
    @IBOutlet weak var zFeedrateField: UITextField!
    @IBOutlet weak var feedLengthField: UITextField!
    @IBOutlet weak var extrudeFeedrateField: UITextField!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var ip = NSUserDefaults.standardUserDefaults().stringForKey("ip")
    var jogIncrement = 0.1
    var xyFeedrate = 3000
    var zFeedrate = 200
    var tempOutput = ""
    var feedLength = 5
    var eFeedrate = 100
    var extruderTemp = 0
    var bedTemp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ipAddress: AnyObject = userDefaults.objectForKey("ip") {
        }else {
            let alert = UIAlertView()
            alert.title = "Set IP address"
            alert.message = "An IP address must be set so SmoothieControl knows where to send your command."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }

        switch(jogIncrementSegment.selectedSegmentIndex){
            case 0:
                jogIncrement = 0.1;
                break;
            case 1:
                jogIncrement = 1;
                break;
            case 2:
                jogIncrement = 10;
                break;
            case 3:
                jogIncrement = 100;
                break;
            default:
                break;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendCommand(cmd: String){
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
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        println("datastring:\(dataString)")
        if(dataString.containsString("ok T:")){
            updateTemp(dataString)
        }
    }
    
    func updateTemp(tempString: String){
        tempOutputField.text = "\(tempString)"
    }
    
    @IBAction func homeXY(sender: AnyObject) {
        sendCommand("G28 XY")
    }
    
    @IBAction func homeZ(sender: AnyObject) {
        sendCommand("G28 Z")
    }

    @IBAction func jogXLeft(sender: AnyObject) {
        sendCommand("G91 G0 X\(-jogIncrement) F\(xyFeedrate) G90")
    }
    @IBAction func jogXRight(sender: AnyObject) {
        sendCommand("G91 G0 X\(jogIncrement) F\(xyFeedrate) G90")
    }
    @IBAction func jogYUp(sender: AnyObject) {
        sendCommand("G91 G0 Y\(jogIncrement) F\(xyFeedrate) G90")
    }
    @IBAction func jogYDown(sender: AnyObject) {
        sendCommand("G91 G0 Y\(-jogIncrement) F\(xyFeedrate) G90")
    }
    @IBAction func jogZUp(sender: AnyObject) {
        sendCommand("G91 G0 Z\(jogIncrement) F\(zFeedrate) G90")
    }
    @IBAction func jogZDown(sender: AnyObject) {
        sendCommand("G91 G0 Z\(-jogIncrement) F\(zFeedrate) G90")
    }
    
    @IBAction func motorsOff(sender: AnyObject) {
        sendCommand("M18")
    }
    @IBAction func setExtruderTemp(sender: AnyObject) {
        extruderTemp = extruderTempField.text.toInt()!
        sendCommand("M104 \(extruderTemp)")
        //dismiss keyboard
        self.view.endEditing(true);
    }
    @IBAction func setBedTemp(sender: AnyObject) {
        bedTemp = bedTempField.text.toInt()!
        sendCommand("M140 \(bedTemp)")
        //dismiss keyboard
        self.view.endEditing(true);
    }
    @IBAction func getTemp(sender: AnyObject) {
        sendCommand("M105")
    }
    @IBAction func extrude(sender: AnyObject) {
        feedLength = feedLengthField.text.toInt()!
        eFeedrate = extrudeFeedrateField.text.toInt()!
        sendCommand("G91 G0 E\(feedLength) F\(eFeedrate) G90")
        //dismiss keyboard
        self.view.endEditing(true);
    }
    @IBAction func retract(sender: AnyObject) {
        feedLength = feedLengthField.text.toInt()!
        eFeedrate = extrudeFeedrateField.text.toInt()!
        sendCommand("G91 G0 E\(-feedLength) F\(eFeedrate) G90")
        //dimsiss keyboard
        self.view.endEditing(true);
    }
    
    @IBAction func jogIncrementChanged(sender: AnyObject) {
        switch(jogIncrementSegment.selectedSegmentIndex){
            case 0:
                jogIncrement = 0.1;
                break;
            case 1:
                jogIncrement = 1;
                break;
            case 2:
                jogIncrement = 10;
                break;
            case 3:
                jogIncrement = 100;
                break;
            default:
                break;
        }
    }
    
    @IBAction func setFeedrate(sender: AnyObject) {
        xyFeedrate = xyFeedrateField.text.toInt()!
        zFeedrate = zFeedrateField.text.toInt()!
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
}
