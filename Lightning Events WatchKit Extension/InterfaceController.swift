//
//  InterfaceController.swift
//  Lightning Events WatchKit Extension
//
//  Created by Skip Sauls on 10/19/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    var session : WCSession!

    var recordSummaries = [RecordSummary]()
    
    var items = [WKPickerItem]()

    @IBOutlet var picker: WKInterfacePicker!
    
    var evtUtil = WatchEventUtil();
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData) {
        print("session.didReceiveMessageDataL \(messageData)");
        
        /* HERE */
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        
        
        let MessageType = (message["MessageType"] as? String)!
        print("MessageType: \(MessageType)");
        
        /*
         * Move all of this to MessageHandler, refactor data objects, etc.
         */
        if (MessageType == "RecordSummary") {
            let Id = (message["Id"] as? String)!
            let Name = (message["Name"] as? String)!
            let sobjectType = (message["sobjectType"] as? String)!
            print("Id: \(Id)");
            print("Name: \(Name)");
            print("sobjectType: \(sobjectType)");
            
            // Not good, use map/dict/etc. instead
            var exists = false;
            for recordSummary:RecordSummary in recordSummaries {
                if (recordSummary.Id == Id) {
                    exists = true;
                }
            }
            
            if (!exists) {
                let recordSummary = RecordSummary()
                recordSummary.Id = Id;
                recordSummary.Name = Name;
                recordSummary.sobjectType = sobjectType;
                print("recordSummary: \(recordSummary)");
                
                recordSummaries.insert(recordSummary, atIndex: 0);
                
                let item = WKPickerItem();
                item.title = Name;
                items.insert(item, atIndex: 0);
            }
            
            
        } else if (MessageType == "Notification") {
            
            MessageHandler.handleMessage(self, message: message);
/*
            print("Notification: \(message)");
            let type = (message["Type"] as? String)!
            let messageBody = (message["MessageBody"] as? String)!
            let messageTitle = (message["MessageTitle"] as? String)!
            let image = (message["Image"] as? String)!
            let lastModified = (message["LastModified"] as? String)!
            
            print("messageTitle: \(messageTitle)");
*/
        }
        
        picker.setItems(items)
        
        return;
    }

    @IBAction func selectItem(value: Int) {
        print("selectItem: \(value)");
        
        //self.updateUserActivity(Shared.sharedUserActivityType, userInfo: [Shared.sharedIdentifierKey : 123456], webpageURL: nil);
        
        let recordSummary = recordSummaries[value] as RecordSummary;
        print("recordSummary: \(recordSummary)");
        
        evtUtil.navigateToSObject(recordSummary.Id, resetHistory: true);

    }
}
