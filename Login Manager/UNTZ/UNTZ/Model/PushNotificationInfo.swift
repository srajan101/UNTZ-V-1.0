//
//  PushNotificationInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 30/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PushNotificationInfo: NSObject {
    var numberOfItemsPerPage: Int?
    var nextIndex: Int?
    var notificationList: [NotificationRespone]? = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["numberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["nextIndex"] as? Int
        
        if let notificationInfos = jsonDict["items"] as? Array<Dictionary<String, AnyObject>> {
            for notificationInfo in notificationInfos{
                let eventsInfo = NotificationRespone.init(jsonDict: notificationInfo)
                self.notificationList?.append(eventsInfo)
            }
        }
    }
    
    func appendData(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["numberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["nextIndex"] as? Int
        
        if let notificationInfos = jsonDict["items"] as? Array<Dictionary<String, AnyObject>> {
            for notificationInfo in notificationInfos{
                let eventsInfo = NotificationRespone.init(jsonDict: notificationInfo)
                self.notificationList?.append(eventsInfo)
            }
        }
    }
}
