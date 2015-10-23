//
//  MessageHandler.swift
//  Lightning Events
//
//  Created by Skip Sauls on 10/23/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import Foundation
import WatchKit

class MessageHandler {
    
    static func handleMessage(controller: WKInterfaceController, message: [String : AnyObject]) {

        let MessageType = (message["MessageType"] as? String)!
        print("MessageType: \(MessageType)");
        
        if (MessageType == "RecordSummary") {
            let Id = (message["Id"] as? String)!
            let Name = (message["Name"] as? String)!
            let sobjectType = (message["sobjectType"] as? String)!
            print("Id: \(Id)");
            print("Name: \(Name)");
            print("sobjectType: \(sobjectType)");
            
            // Move from InterfaceController
            
        } else if (MessageType == "Notification") {
            
            print("Notification: \(message)");
            let type = (message["Type"] as? String)!
            let messageBody = (message["MessageBody"] as? String)!
            let messageTitle = (message["MessageTitle"] as? String)!
            let image = (message["Image"] as? String)!
            let lastModified = (message["LastModified"] as? String)!
            
            print("messageTitle: \(messageTitle)");
            
            controller.presentControllerWithName("Notifications", context: message);
            //controller.pushControllerWithName("Notifications", context: message);
        }
    }
}
