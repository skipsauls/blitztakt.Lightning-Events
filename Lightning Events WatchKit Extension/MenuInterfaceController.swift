//
//  MenuInterfaceController.swift
//  Lightning Events
//
//  Created by Skip Sauls on 10/21/15.
//  Copyright © 2015 Skip Sauls. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MenuInterfaceController: WKInterfaceController,WCSessionDelegate {
    var session : WCSession!
    
    @IBOutlet var accountButton: WKInterfaceButton!
    
    let evtUtil = WatchEventUtil();
    
    let menus = [
        [
            "scope":"Account",
            "label":"Accounts",
            "type":"ObjectHome"
        ],
        [
            "scope":"Opportunity",
            "label":"Opportunities",
            "type":"ObjectHome"
        ],
        [
            "scope":"Order",
            "label":"Orders",
            "type":"ObjectHome"
        ],
        [
            "scope":"Approval",
            "label":"Approvals",
            "type":"Component"
        ],
        [
            "scope":"Feed",
            "label":"Feed",
            "type":"Component"
        ],
        [
            "scope":"CollaborationGroup",
            "label":"Groups",
            "type":"ObjectHome"
        ],
        [
            "scope":"User",
            "label":"People",
            "type":"ObjectHome"
        ]
    ];
    
    let componentConfig = [
        "Approval": [
            "componentDef":"force:filterList",
            "componentAttributes": [
                "filterTitle": "Approvals",
                "filterName": "Workitem",
                "showFilterPicker": "false",
                "entityName": "ProcessInstanceWorkitem"
            ]
        ],
        "Feed": [
            "componentDef":"one:chatter",
            "componentAttributes": [
                "":""
            ]

        ]
    ];

    @IBOutlet var menuTableRowController: MenuTableRowController!
    @IBOutlet var menuTable: WKInterfaceTable!
    
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
    
    override init() {
        super.init();

        let maxRows = menus.count;
        print("maxRows: \(maxRows)");

        menuTable.setNumberOfRows(menus.count, withRowType: "MenuTableRowController")
        
        //menus.keys
        //var range = 0...maxRows;
        
        for (index, _) in menus.enumerate() {
            let row = menuTable.rowControllerAtIndex(index) as! MenuTableRowController;
            row.label.setText(menus[index]["label"]);
            row.image.setImageNamed(menus[index]["label"]);
        }

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        
        MessageHandler.handleMessage(self, message: message);
        
        return;
    }
    
    @IBAction func accountSelected() {
        print("accountSelected");
        evtUtil.navigateToObjectHome("Account", resetHistory: true);
        
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print("selected: \(rowIndex)");
        let menu = menus[rowIndex];
        let type: String = menu["type"]!;
        let scope: String = menu["scope"]!;
        print("scope: \(scope)");
        if (type == "ObjectHome") {
            evtUtil.navigateToObjectHome(scope, resetHistory: false);
        } else if (type == "Component") {
            let config = componentConfig[scope] as! [String: AnyObject];
            let componentDef = config["componentDef"] as! String;
            evtUtil.navigateToComponent(componentDef, componentConfig: config, resetHistory: true);
        }
        
        //let scope: String = menus[rowIndex]["scope"]!;
    
        
        
        
        // Redirect to controller with unit instance
        //self.pushControllerWithName("anotherController", context: rowIndex))
    }
}