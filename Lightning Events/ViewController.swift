//
//  ViewController.swift
//  Lightning Events
//
//  Created by Skip Sauls on 10/19/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import UIKit
import WebKit
import WatchConnectivity

class ViewController: UIViewController, WKNavigationDelegate, WCSessionDelegate, WKScriptMessageHandler {

    @IBOutlet var theView: UIView!;
    
    @IBOutlet weak var testButton: UIButton!;
    
    var webView: WKWebView?;
    
    var session: WCSession!;
    
    // Track the events (change to FIFO queue, etc.?)
    var events = [LtngEvent]();

    required init(coder aDecoder: NSCoder) {
        
        self.webView = WKWebView(frame: CGRectZero);
        
        super.init(coder: aDecoder)!
        
        

    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
    }
    
    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.sharedApplication().endBackgroundTask(taskID)
    }
    
    override func viewWillAppear(animated: Bool) {
        let gap: CGFloat = 24.0;
        
        var viewBounds: CGRect = self.webView!.bounds;
        viewBounds.origin.y = gap;
        viewBounds.size.height -= gap;
        self.webView!.frame = viewBounds;

        self.webView!.backgroundColor = UIColor(red: 0.22, green: 0.5, blue: 0.92, alpha: 1.0);

        // Not having the desired effect!
        /*
        self.webView!.scrollView.backgroundColor = UIColor(red: 0.22, green: 0.5, blue: 0.92, alpha: 1.0);
\        self.webView!.scrollView.contentInset = UIEdgeInsetsMake(gap, 0.0, 0.0, 0.0);
        */
        
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear");
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        print("hidden: \(self.navigationController?.navigationBarHidden)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("$$$$$$$$$$$$$$$$$$$$$ viewDidLoad");
        // Do any additional setup after loading the view, typically from a nib.

        //var url = NSURL(string:"http://octane-benchmark.googlecode.com/svn/latest/index.html")
        let url = NSURL(string:"https://ltngout-dev-ed.lightning.force.com/one/one.app")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }

    override func loadView() {
        super.loadView()
        
        print("########################### loadView");
        
        
        let name = SObjectUtils.getNameFromRecordId("0010D00000BXCX1");
        print("name: \(name)")
        
        let contentController = WKUserContentController();
        
        if let scriptFile = NSBundle.mainBundle().pathForResource("blitztakt", ofType: "js") {
            print("scriptFile: \(scriptFile)");
            
            //let bundle = NSBundle.mainBundle()
            
            let scriptString: NSString?
            do {
                scriptString = try NSString(contentsOfFile: scriptFile, encoding: NSUTF8StringEncoding)
            } catch _ {
                scriptString = nil
                print("Could not load \(scriptFile)")
            }
            
            print("scriptString \(scriptString)");
            
            if scriptString != nil {
                if let scriptString = scriptString {
                    let script = WKUserScript(
                        source: scriptString as String,
                        injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
                        forMainFrameOnly: true)
                    contentController.addUserScript(script)
                }
            }
        }
        
        contentController.addScriptMessageHandler(
            self,
            name: "callbackHandler"
        )
        
        contentController.addScriptMessageHandler(
            self,
            name: "recordSummariesHandler"
        )

        contentController.addScriptMessageHandler(
            self,
            name: "mostRecentNotificationHandler"
        )

        let config = WKWebViewConfiguration();
        config.userContentController = contentController;
        self.webView = WKWebView(frame: CGRectZero, configuration: config);
        self.view = webView;
        
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            print("callbackHandler \(message.body)")
            //sendToWatch(message.body as! NSString)
            
            let jsonString = message.body
            print("jsonString: \(jsonString)")
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let evt = JSON(data: dataFromString)
                showEventDetails(evt)
                sendEventRefToWatch(evt)
                //sendEventToWatch(evt)
                
            }
        } else if (message.name == "recordSummariesHandler") {
            print("recordSummariesHandler \(message.body)")
            let jsonString = message.body
            print("jsonString: \(jsonString)")
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let summaries = JSON(data: dataFromString)
                showRecordSummaries(summaries)
                sendRecordSummariesToWatch(summaries)
            }
            
        } else if (message.name == "mostRecentNotificationHandler") {
            print("mostRecentNotificationHandler \(message.body)")
            let jsonString = message.body
            print("jsonString: \(jsonString)")
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let notifications = JSON(data: dataFromString)
                showNotifications(notifications)
                sendNotificationsToWatch(notifications)
            }
            
        }
    }
    
    
    @IBAction func test(sender: AnyObject) {
        print("test");
    }
    
    func showRecordSummaries(summaries: JSON) {
        print("showRecordSummaries: \(summaries)");
        var Id: String;
        var Name: String;
        var sobjectType: String;
        for summary:JSON in summaries.arrayValue {
            print("summary: \(summary)");
            Id = summary["Id"].stringValue;
            Name = summary["Name"].stringValue;
            sobjectType = summary["sobjectType"].stringValue;
            print("Id: \(Id)");
            print("Name: \(Name)");
            print("sobjectType: \(sobjectType)");
        }
        
    }

    func showNotifications(notifications: JSON) {
        print("showNotifications: \(notifications)");
        /*
        var Id: String;
        var Name: String;
        var sobjectType: String;
        for summary:JSON in summaries.arrayValue {
            print("summary: \(summary)");
            Id = summary["Id"].stringValue;
            Name = summary["Name"].stringValue;
            sobjectType = summary["sobjectType"].stringValue;
            print("Id: \(Id)");
            print("Name: \(Name)");
            print("sobjectType: \(sobjectType)");
        }
        */
    }

    func showEventDetails(evt: JSON) {
        print("showEventDetails: \(evt)");
        let name = evt["name"].stringValue;
        print("name: \(name)")
        let namespace = evt["namespace"].stringValue;
        print("namespace: \(namespace)")
        let qualifiedName = evt["qualifiedName"].stringValue;
        print("qualifiedName: \(qualifiedName)")
        let prefix = evt["prefix"].stringValue;
        print("prefix: \(prefix)")
        let type = evt["type"].stringValue
        print("type: \(type)");
        let params = evt["params"]
        for (key, val):(String, JSON) in params {
            print("key: \(key) ,val: \(val)")
        }
        let timestamp = evt["timestamp"].intValue;
        print("timestamp: \(timestamp)")
    }
    
    func sendEventRefToWatch(evt: JSON) {
        
        return;
        
        /*
        SIMPLIFY!
        
        - Store the events on the phone (fixed-size fifo queue?)
        - Send only the display info (type, title, icon, actions, etc.) and uid to the watch
        - Watch sends back only the uid and selected action
        - Fire the event specified by the action
        
        - Actions:
        - Record: View, Edit
        - Tab: View
        - Navigate: Back, Home
        - Respond: Approve, Deny, etc. (may be too open-ended) <- Can this map to the dialogs, etc.?
        
        */
        
        // Create the LtngEvent to store the event details
        let event = LtngEvent()
        event.prefix = evt["prefix"].stringValue
        event.name = evt["name"].stringValue
        event.namespace = evt["namespace"].stringValue
        event.qualifiedName = evt["qualifiedName"].stringValue
        event.type = evt["type"].stringValue
        event.timestamp = String(evt["timestamp"])
        event.uuid = NSUUID().UUIDString
        
        event.params = [String:String]()
        
        let params = evt["params"]
        
        for (key, val):(String, JSON) in params {
            print("key: \(key) ,val: \(val)")
            event.params[key] = val.stringValue
        }
        
        //print("event: \(event)")
        
        events.append(event)
        
        if (event.name == "navigateToSObject") {
            let recordId = event.params["recordId"]
            print("recordId: \(recordId)")
            let sobjectName = SObjectUtils.getNameFromRecordId(recordId! as! String)
            print("sobjectName: \(sobjectName)")
            
            let messageToSend = [
                "uuid": event.uuid,
                "title": sobjectName
            ];
            
        } else if (event.name == "navigateToComponent") {
            
        } else if (event.namespace == "forceSearch" && event.name == "searchContext") {
            let scope = event.params["scope"];
            let scopeLabel = event.params["scopeLabel"];
            let scopeIcon = event.params["scopeIcon"];
            let scopeColor = event.params["scopeColor"];
            let messageToSend = [
                "scope": scope,
                "scopeLabel": scopeLabel,
                "scopeIcon": scopeIcon,
                "scopeColor": scopeColor
            ];
        
            print("messageToSend: \(messageToSend)");
        }
    }

    func sendNotificationsToWatch(notifications: JSON) {
        print("sendNotificationToWatch: \(notifications)");
        
        var type: String;
        var messageBody: String;
        var messageTitle: String;
        var image: String;
        var lastModified: String;
        
        for notification:JSON in notifications.arrayValue {
            print("notification: \(notification)");
            
            type = notification["type"].stringValue;
            messageBody = notification["messageBody"].stringValue;
            messageTitle = notification["messageTitle"].stringValue;
            image = notification["image"].stringValue;
            lastModified = notification["lastModified"].stringValue;
            
            let messageToSend = [
                "MessageType": "Notification",
                "Type": type,
                "MessageBody": messageBody,
                "MessageTitle": messageTitle,
                "Image": image,
                "LastModified": lastModified
            ];

            print("messageToSend: \(messageToSend)");

            session.sendMessage(messageToSend, replyHandler: { replyMessage in
                print("replyMessage: \(replyMessage)");
                }, errorHandler: {error in
                    // catch any errors here
                    print(error)
            });
        }
    }
    
    func sendRecordSummariesToWatch(summaries: JSON) {
        print("sendRecordSummariesToWatch: \(summaries)");
        var Id: String;
        var Name: String;
        var sobjectType: String;
        for summary:JSON in summaries.arrayValue {
            print("summary: \(summary)");
            Id = summary["Id"].stringValue;
            Name = summary["Name"].stringValue;
            sobjectType = summary["sobjectType"].stringValue;
            print("Id: \(Id)");
            print("Name: \(Name)");
            print("sobjectType: \(sobjectType)");
            let messageToSend = [
                "MessageType": "RecordSummary",
                "Id": Id,
                "Name": Name,
                "sobjectType": sobjectType
            ];
            
            print("messageToSend: \(messageToSend)");
            
/*
            var evt: LtngEvent = LtngEvent();
            evt.namespace = "force";
            evt.name = "navigateToSObject";
            evt.params = [
                "recordId": Id,
                "resetHistory": true
            ];
            
            print("LtngEvent evt \(evt)");
            
            session.sendMessageData(evt, replyHandler: { replyMessage in
*/
            
            session.sendMessage(messageToSend, replyHandler: { replyMessage in
                print("replyMessage: \(replyMessage)");
                /*
                let value = replyMessage["Value"] as? String
                //use dispatch_async to present immediately on screen
                dispatch_async(dispatch_get_main_queue()) {
                self.messageLabel.text = value
                }
                */
                }, errorHandler: {error in
                    // catch any errors here
                    print(error)
            });
            
        }
    }
    
    func sendEventToWatch(evt: JSON) {
        
        let name = evt["name"].stringValue;
        let namespace = evt["namespace"].stringValue;
        let qualifiedName = evt["qualifiedName"].stringValue;
        let prefix = evt["prefix"].stringValue;
        let type = evt["type"].stringValue
        let params = evt["params"]
        let timestamp = String(evt["timestamp"]);
        
        var messageToSend = [
            "namespace": namespace,
            "name": name
        ]
        
        for (key, val):(String, JSON) in params {
            print("key: \(key) , val: \(val), val type: \(val.type)")
            messageToSend["param_\(key)"] = val.stringValue
        }
        
        messageToSend["qualifiedName"] = qualifiedName
        messageToSend["prefix"] = prefix;
        messageToSend["type"] = type;
        messageToSend["timestamp"] = timestamp;
        
        print("messageToSend: \(messageToSend)")
        
        session.sendMessage(messageToSend, replyHandler: { replyMessage in
            let value = replyMessage["Value"] as? String
            //use dispatch_async to present immediately on screen
            dispatch_async(dispatch_get_main_queue()) {
                //self.messageLabel.text = value
            }
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
    }
    
    func sendToWatch(msg: NSString) {
        let messageToSend = ["Value":msg]
        
        session.sendMessage(messageToSend, replyHandler: { replyMessage in
            //handle the reply
            let value = replyMessage["Value"] as? String
            //use dispatch_asynch to present immediately on screen
            dispatch_async(dispatch_get_main_queue()) {
                //self.messageLabel.text = value
            }
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
        
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        //let value = message["Value"] as? String
        
        let MessageType = (message["MessageType"] as? String)!
        print("MessageType: \(MessageType)");
        
        if (MessageType == "SelectRecord") {
            let Id = (message["Id"] as? String)!
            
            let namespace = "force";
            let name = "navigateToSObject";
            var params = "{";
            params += "\"recordId\":\"\(Id)\"";
            params += ",\"resetHistory\":true";
            params += "}";
            //let paramKey = "recordId";
            //let paramValue = Id;
            
            let jsString = "blitztakt.fireEvent('" + namespace + ":" + name + "'," + params + ")";
            print("jsString: \(jsString)")
            self.webView!.evaluateJavaScript(jsString, completionHandler: nil)
        } else if (MessageType == "FireEvent") {
            let name = (message["name"] as? String)!
            let namespace = (message["namespace"] as? String)!
            
            
            var params = "{";
            var count = 0;
            
            let mparams = (message["params"] as? [String: AnyObject]);
            for (key, val):(String, AnyObject) in mparams! {
                print("key: \(key): val: \(val)");
                
                if (key == "componentAttributes") {
                    params += count > 0 ? "," : "";
                    params += "\"\(key)\":{";
                    var ccount = 0;
                    let compAttr = val as! [String: AnyObject];
                    for (ckey, cval):(String, AnyObject) in compAttr {
                        print("ckey: \(ckey) - cval: \(cval)");
                        params += ccount > 0 ? "," : "";
                        params += "\"\(ckey)\":\"\(cval)\"";
                        ccount++;
                    }
                    params += "}";
                } else {
                    params += count > 0 ? "," : "";
                    params += "\"\(key)\":\"\(val)\"";
                }
                count++;
            }

            params += "}";

            
            let jsString = "blitztakt.fireEvent('" + namespace + ":" + name + "'," + params + ")";
            
            print("jsString: \(jsString)")
            
            self.webView!.evaluateJavaScript(jsString, completionHandler: nil)
        }
        
    }
    
    
    
}

