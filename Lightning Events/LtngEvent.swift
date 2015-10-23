//
//  LtngEvent.swift
//  SendMessageWatch
//
//  Created by Skip Sauls on 9/29/15.
//  Copyright © 2015 SkipSauls. All rights reserved.
//

import Foundation

class LtngEvent: NSData {
    var prefix: String = ""
    var namespace: String = ""
    var name: String = ""
    var qualifiedName: String = ""
    var type: String = ""
    var timestamp: String = ""
    var params: [String: AnyObject] = [:]
    var uuid: String = ""    
}