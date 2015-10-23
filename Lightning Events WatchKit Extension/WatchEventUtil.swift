//
//  WatchEventUtil.swift
//  Lightning Events
//
//  Created by Skip Sauls on 10/21/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchEventUtil {
    var session : WCSession!
    
    func setSession(session: WCSession) {
        self.session = session;
    }
    
    func navigateToObjectHome(scope: String, resetHistory: Bool) {
        let messageToSend = [
            "MessageType": "FireEvent",
            "namespace": "force",
            "name": "navigateToObjectHome",
            "params": [
                "scope": scope,
                "resetHistory": resetHistory
            ]
        ];
        sendMessage(messageToSend);
    }
    
    func navigateToSObject(recordId: String, resetHistory: Bool) {
        /*
        let messageToSend = [
            "MessageType": "SelectRecord",
            "Id": recordId
        ];
        */
        
        let messageToSend = [
            "MessageType": "FireEvent",
            "namespace": "force",
            "name": "navigateToSObject",
            "params": [
                "recordId": recordId,
                "resetHistory": resetHistory
            ]
        ];
        
        sendMessage(messageToSend);
    }

    func navigateToComponent(componentDef: String, componentConfig: [String: AnyObject], resetHistory: Bool) {
        let componentDef = componentConfig["componentDef"] as! String;
        /*
        var componentAttributes: [String: AnyObject] = ["":""];
        if (componentConfig["componentAttributes"] != nil) {
            componentAttributes = componentConfig["componentAttributes"] as! [String: AnyObject];
        }
        */
        let componentAttributes = componentConfig["componentAttributes"] as! [String: AnyObject];
        
        let messageToSend = [
            "MessageType": "FireEvent",
            "namespace": "force",
            "name": "navigateToComponent",
            "params": [
                "componentDef": componentDef,
                "componentAttributes": componentAttributes,
                "resetHistory": resetHistory
            ]
        ];
        sendMessage(messageToSend);
    }

    func sendMessage(messageToSend: [String: AnyObject]) {
        print("messageToSend: \(messageToSend)");
        
        let message = messageToSend;
        let name = (message["name"] as? String)!
        let namespace = (message["namespace"] as? String)!
        print("namespace: \(namespace)");
        print("name: \(name)");
       
        /*
        for (key, val) in messageToSend {
            print("key: \(key): val: \(val)");
            
        }
        */

        let params = message["params"] as! [String: AnyObject]

        for (key, val):(String, AnyObject) in params {
            print("key: \(key): val: \(val)");
        }

        if (session != nil) {
            session.sendMessage(messageToSend, replyHandler: { replyMessage in
                //handle and present the message on screen
                let value = replyMessage["Value"] as? String
                //self.messageLabel.setText(value)
                }, errorHandler: {error in
                    // catch any errors here
                    print(error)
            })
            
        }
    }
}
