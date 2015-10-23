console.warn("blitztakt.js!");

function foo() {
    console.warn("foo!");
}

var blitztakt = blitztakt ? blitztakt : {};

blitztakt.init = function() {
    console.warn("blitztakt.init");
};

/*
blitztakt.fireEvent = function(evtName, paramKey, paramValue) {
    console.warn("blitztakt.fireEvent: ", evtName, paramKey, paramValue);
    var evt = $A.getEvt(evtName);
    var params = {};
    params[paramKey] = paramValue;
    evt.setParams(params);
    evt.fire();
};
*/

blitztakt.fireEvent = function(evtName, params) {
    console.warn("blitztakt.fireEvent: ", evtName, params);
    var evt = $A.getEvt(evtName);
    evt.setParams(params);
    evt.fire();
};

blitztakt.sendMessage = function(evt) {
    console.warn("blitztakt.sendMessage: ", evt);
    try {
        var def = evt.getDef();
        var desc = def.getDescriptor();
        var data = {
        type: def.getEventType(),
        params: evt.getParams(),
        namespace: desc.getNamespace(),
        name: desc.getName(),
        prefix: desc.getPrefix(),
        qualifiedName: desc.getQualifiedName(),
        attributeDefs: def.getAttributeDefs(),
        timestamp: Date.now()
        };
        console.warn("data: ", data);
        var jsonData = JSON.stringify(data);
        console.warn("jsonData: ", jsonData);
        webkit.messageHandlers.callbackHandler.postMessage(jsonData);
    } catch(err) {
        console.warn("The native context does not exist yet");
    }
};

blitztakt.selectRecord = function(value, oldValue) {
    console.warn("blitztakt.selectRecord: ", value, oldValue);
    try {
        var valueJson = JSON.stringify(value);
        var oldValueJson = JSON.stringify(oldValue);
        if (valueJson === oldValueJson) {
            console.warn("value and oldValue match");
        } else {
            console.warn("valueJson: ", valueJson);
            webkit.messageHandlers.selectRecordHandler.postMessage(valueJson);
        }
    } catch(err) {
        console.warn("The native context does not exist yet");
    }
    
}

blitztakt.sendRecordSummaries = function(summaries) {
    console.warn("blitztakt.sendRecordSummaries: ", summaries);
    try {
        var jsonData = JSON.stringify(summaries);
        console.warn("jsonData: ", jsonData);
        webkit.messageHandlers.recordSummariesHandler.postMessage(jsonData);
    } catch(err) {
        console.warn("The native context does not exist yet");
    }
    
}

// Shhhhh...
blitztakt.getRecords = function(callback) {
    console.warn("getRecords");
    var records = null;
    var ss = $A.storageService.getStorages();
    console.warn("ss: ", ss);
    if (typeof ss.recordGVP !== "undefined") {
        var all = ss.recordGVP.getAll();
        all.then(function(a) {
                 console.warn("a: ", a);
                 for (var i = 0; i < a.length; i++) {
                 console.warn("a[", i, "]: ", a[i], a[i].key);
                 if (a[i].key === "_records") {
                 records = [];
                 var record = null;
                 for (var id in a[i].value) {
                 console.warn("id: ", id, ", record: ", a[i].value[id].record);
                 record = a[i].value[id].record;
                 records.push(record);
                 console.warn(record.Id, " - ", record.Name, " - " , record.sobjectType);
                 }
                 }
                 }
                 if (typeof callback === "function") {
                 callback(records);
                 }
                 });
    } else {
        if (typeof callback === "function") {
            callback(records);
        }
    }
}

blitztakt.getRecordSummaries = function() {
    console.warn("getRecordSummaries");
    var summaries = null;
    var self = this;
    this.getRecords(function(records) {
                    console.warn("records: ", records);
                    if (records !== null && typeof records !== "undefined") {
                    summaries = [];
                    for (var i = 0; i < records.length; i++) {
                    summaries.push({Id: records[i].Id, Name: records[i].Name, sobjectType: records[i].sobjectType});
                    }
                    }
                    self.sendRecordSummaries(summaries);
                    });
}

blitztakt.getNotifications = function(callback) {
    var notifications = {};
    var ss = $A.storageService.getStorages();
    console.warn("ss: ", ss);
    if (typeof ss.actions !== "undefined") {
        var all = ss.actions.getAll();
        all.then(function(a) {
                 console.warn("a: ", a);
                 for (var i = 0; i < a.length; i++) {
                 console.warn("a[", i, "]: ", a[i], a[i].key);
                 if (a[i].key.indexOf("serviceComponent://ui.aura.components.force.notifications") >= 0) {
                 var notification = null;
                 for (var name in a[i].value) {
                 console.warn("name: ", name);
                 if (name === "returnValue") {
                 console.warn("iterating over: ", a[i].value[name]);
                 var nval = null;
                 for (var j = 0; j < a[i].value[name].length; j++) {
                 nval = a[i].value[name][j];
                 if (nval instanceof Array) {
                 for (var k = 0; k < nval.length; k++) {
                 notification = nval[k];
                 console.warn("notification: ", notification);
                 notifications[notification.lastModified] = notification;
                 }
                 }
                 }
                 }
                 }
                 }
                 }
                 if (typeof callback === "function") {
                 callback(notifications);
                 }
                 });
    }
}

blitztakt.getMostRecentNotification = function() {
    var notifications = {};
    var notificationArray = [];
    var self = this;
    this.getNotifications(function(notifications) {
                          for (var key in notifications) {
                          notificationArray.push(notifications[key]);
                          }
                          notificationArray.sort(function(a, b) {
                                                 a = new Date(a.lastModified);
                                                 b = new Date(b.lastModified);
                                                 return a>b ? -1 : a<b ? 1 : 0;
                                                 });
                          console.warn("notificationArray: ", notificationArray);
                          self.sendMostRecentNotification(notificationArray[0]);
                          });
}

blitztakt.lastNotificationDate = null;

blitztakt.sendMostRecentNotification = function(notification) {
    console.warn("blitztakt.sendMostRecentNotification: ", notification);
    if (this.lastNotificationDate !== notification.lastModified) {
        this.lastNotificationDate = notification.lastModified;
        try {
            var jsonData = JSON.stringify([notification]);
            console.warn("jsonData: ", jsonData);
            webkit.messageHandlers.mostRecentNotificationHandler.postMessage(jsonData);
        } catch(err) {
            console.warn("The native context does not exist yet");
        }
    }
    
}

blitztakt.addHandler = function(evtName, callback) {
    var self = this;
    $A.eventService.addHandler({
        event: evtName,
        handler: function(evt) {
            console.warn("handle" + evtName + ": ", evt, evt.getParams());
            self.sendMessage(evt);
            if (typeof callback === "function") {
                callback.call();
            }
        }
    });
}

blitztakt.addHandlers = function() {
    console.warn("blitztakt.addHandlers");
    var self = this;
    
    self.addHandler("force:navigateToSObject", function() {
        window.setTimeout(
            $A.getCallback(function() {
                self.getRecordSummaries();
            }), 2000
        );
                    
    });
    
    self.addHandler("forceSearch:searchContext");
    self.addHandler("force:navigateToComponent");
    self.addHandler("force:localRecordChangeCheck");
    self.addHandler("one:updateHeader");
    self.addHandler("ui:dataChanged");
    
    self.addHandler("auraStorage:modified", function() {
        self.getMostRecentNotification();
    });
    
    return;
    
    $A.eventService.addHandler({
                               event: "force:navigateToSObject",
                               handler: function(evt) {
                               console.warn("handle force:navigateToSObject: ", evt, evt.getParams());
                               self.sendMessage(evt);
                               // Send the record summaries whenever there is a change...
                               window.setTimeout(
                                                 $A.getCallback(function() {
                                                                self.getRecordSummaries();
                                                                }), 2000
                                                 );
                               }
                               });
    
    $A.eventService.addHandler({
                               event: "force:navigateToComponent",
                               handler: function(evt) {
                               console.warn("handle force:navigateToComponent: ", evt, evt.getParams());
                               self.sendMessage(evt);
                               }
                               });

    $A.eventService.addHandler({
                               event: "one:updateHeader",
                               handler: function(evt) {
                               console.warn("handle one:udpateHeader: ", evt, evt.getParams());
                               self.sendMessage(evt);
                               }
                               });

    $A.eventService.addHandler({
                               event: "force:localRecordChangeCheck",
                               handler: function(evt) {
                               console.warn("handle force:localRecordChangeCheck: ", evt, evt.getParams());
                               self.sendMessage(evt);
                               }
                               });

}


blitztakt.init();
blitztakt.addHandlers();
