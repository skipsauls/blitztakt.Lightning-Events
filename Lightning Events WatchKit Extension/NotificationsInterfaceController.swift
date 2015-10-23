//
//  NotificationsInterfaceController.swift
//  Lightning Events
//
//  Created by Skip Sauls on 10/23/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class NotificationsInterfaceController: WKInterfaceController,WCSessionDelegate {
    var session : WCSession!

    let evtUtil = WatchEventUtil();
    
    @IBOutlet var messageTitle: WKInterfaceLabel!
    @IBOutlet var messageBody: WKInterfaceLabel!
    @IBOutlet var viewButton: WKInterfaceButton!
    @IBOutlet var dismissButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        print("notificationsInterfaceController.awakeWithContext: \(context)");
        
        let message = context as! [String: AnyObject];
        
        let type = (message["Type"] as? String)!
        let body = (message["MessageBody"] as? String)!
        let title = (message["MessageTitle"] as? String)!
        let image = (message["Image"] as? String)!
        let lastModified = (message["LastModified"] as? String)!
        
        messageBody.setText(body);
        messageTitle.setText(title);
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession();
            
            evtUtil.setSession(session);
        }
    }
    
    @IBAction func viewPushed() {
        print("view");
        // Fire an event to display on phone, may need ID, etc.
        self.dismissController();
        
    }
    
    @IBAction func dismissPushed() {
        print("dismiss");
        self.dismissController();
    }
}