//
//  NotificationRespone.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 14/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class NotificationRespone: NSObject {
    var notificationId : Int?
    var userId : Int?
    var notificationTextFormat : String?
    var notificationType : String?
    var notificationFormatModel : NotificationFormatTokenModel?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.notificationId = jsonDict["id"] as? Int
        self.userId = jsonDict["userId"] as? Int
        self.notificationTextFormat = jsonDict["notificationTextFormat"] as? String
        self.notificationType = jsonDict["notificationType"] as? String
        
        let notificationFormatModelDic = jsonDict["notificationFormatTokenModel"] as? Dictionary<String, AnyObject>
        if let notificationFormatModelDic = notificationFormatModelDic {
            self.notificationFormatModel = NotificationFormatTokenModel.init(jsonDict: notificationFormatModelDic)
        }
        
    }
}
