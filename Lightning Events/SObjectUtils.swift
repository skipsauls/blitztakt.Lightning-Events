//
//  File.swift
//  SendMessageWatch
//
//  Created by Skip Sauls on 9/29/15.
//  Copyright © 2015 SkipSauls. All rights reserved.
//

import Foundation

class SObjectUtils {
    
    static func getName(prefix: String) -> String {
        let name = prefixMap[prefix]
        print("name: \(name)")
        return (prefixMap[prefix] ?? nil)!
    }

    static func getNameFromRecordId(recordId: String) -> String {
        let prefix = (recordId as NSString).substringToIndex(3)
        print("prefix: \(prefix)")
        return getName(prefix)
    }

    static var prefixMap: [String: String] = [
        "03G": "Account Criteria Share",
        "001": "Account",
        "00r": "Account Share",
        "007": "Activity",
        "04m": "Additional Directory Number",
        "01p": "Apex Class",
        "707": "Apex Job",
        "01q": "Apex Trigger",
        "07L": "Apex Debug Log",
        "07M": "Apex Test Result",
        "0DS": "App Menu Item",
        "806": "Approval",
        "04i": "Approval Request",
        "ka0": "Article",
        "02i": "Asset",
        "00P": "Attachment",
        "01m": "Business Hours",
        "019": "Business process",
        "04v": "Call Center",
        "701": "Campaign",
        "00v": "Campaign Member",
        "01Y": "Campaign Member Status",
        "08s": "Campaign Share",
        "07O": "Canvas",
        "500": "Case",
        "00a": "Case Comment",
        "01n": "Case Share",
        "010": "Case Solution",
        "02o": "Category Data",
        "02n": "Category Node",
        "5CS": "Chat Session",
        "0F9": "Chatter Group",
        "0FB": "Chatter Group Member",
        "0ca": "Chatter Activity",
        "09a": "Community",
        "003": "Contact",
        "02Z": "Contact Role",
        "03s": "Contact Share",
        "069": "Content",
        "800": "Contract",
        "811": "Contract Line Item",
        "00b": "Custom Button or Link",
        "01N": "Custom S-Control",
        "02F": "Custom Field Map",
        "02U": "Custom Page",
        "070": "Custom Report Type",
        "03f": "Custom Setup",
        "02c": "Custom Share",
        "0A7": "Custom Share Row Cause",
        "01r": "Custom Tab",
        "01Z": "Dashboard",
        "0FL": "Dashboard Refresh",
        "02f": "Delegated Administration Group",
        "02h": "Delegated Administration Group Assignment",
        "02g": "Delegated Administration Group Member",
        "00C": "Delete Event",
        "02d": "Division",
        "015": "Document",
        "05X": "Document Entity Map",
        "091": "Email Service",
        "093": "Email Services Address",
        "018": "Email Status",
        "00X": "Email Template",
        "02s": "Email Message",
        "058": "Entity Subscription",
        "017": "Entity History",
        "00U": "Event",
        "020": "Event Attendee",
        "0AT": "Event Log File",
        "0IM": "Export",
        "0D7": "Feed Comment",
        "0F7": "Feed Post",
        "0D6": "Feed Tracked Change",
        "07F": "Feed Favorite",
        "0I0": "Feed Like",
        "0II": "Feed Mention",
        "09B": "Feed Poll Vote",
        "737": "Field History",
        "1HA": "Field History Archive",
        "0IX": "Field Set",
        "00B": "Filter",
        "022": "Fiscal Year Settings",
        "01d": "Folder Group",
        "0AF": "Folder Share",
        "608": "Forecast Share",
        "00A": "Forecast Item",
        "0J9": "Forecast Quota",
        "00G": "Group",
        "011": "Group Member",
        "02E": "Help",
        "0C0": "Holiday",
        "087": "Idea",
        "0Bg": "Idea Theme",
        "0ET": "Import",
        "kA#": "Knowledge Article",
        "00h": "Layout",
        "00Q": "Lead",
        "01o": "Lead Share",
        "016": "Letter Head",
        "0Ya": "Login History",
        "02x": "Login Hours",
        "710": "Login IP",
        "01H": "Mail merge Template",
        "07A": "Mass Mail",
        "063": "Mobile Configuration",
        "086": "Mobile Device",
        "0I4": "My Domain",
        "0D5": "News Feed",
        "002": "Note",
        "0JH": "Notification",
        "888": "OAuth",
        "110": "Object Permissions",
        "006": "Opportunity",
        "00J": "Opportunity Competitor",
        "008": "Opportunity History",
        "00t": "Opportunity Share",
        "02r": "Opportunity Big Deal Alert",
        "00K": "Opportunity Contact Role",
        "00k": "Opportunity Line Item",
        "802": "Order Item",
        "801": "Orders",
        "0D2": "Org Wide Email Address",
        "00D": "Organization",
        "04l": "Outbound Message",
        "02l": "Outbound Queue",
        "00l": "Partner",
        "026": "Period",
        "0PS": "Permission Set",
        "0Pa": "Permission Set Assignment",
        "0PL": "Permission Set License",
        "2LA": "Permission Set License Assignment",
        "060": "Portal",
        "061": "Portal Account",
        "067": "Portal Member",
        "01u": "Price Book Entry",
        "01s": "Price Book2",
        "04g": "Process Instance",
        "04h": "Process Instance Step",
        "01t": "Product",
        "00e": "Profile",
        "01k": "Field Level Security",
        "01G": "Profile Layout",
        "01P": "Profile Tab",
        "021": "Quantity Forecast",
        "04X": "Quantity Forecast History",
        "906": "Question",
        "03g": "Queue",
        "0Q0": "Quote",
        "012": "Record Type",
        "00O": "Report",
        "08e": "Scheduled Job",
        "08A": "Scheduled Report",
        "0DM": "Site",
        "04n": "Softphone Layout",
        "501": "Solution",
        "081": "Static Resource",
        "00T": "Task",
        "005": "User",
        "100": "User License",
        "03u": "User Preference",
        "00E": "User Role",
        "099": "Visualforce Component",
        "066": "Visualforce Page",
        "083": "Vote"
    ]
}