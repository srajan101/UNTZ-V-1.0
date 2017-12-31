//
//  UserAccountInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 21/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UserAccountInfo: NSObject {
    var userId: Int?
    var aspNetUserId: String?
    var facebookUserId: String?
    var pictureUrl: String?
    var userName: String?
    var fullName: String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.userId = jsonDict["id"] as? Int
        self.facebookUserId = jsonDict["facebookUserId"] as? String
        self.userName = jsonDict["userName"] as? String
        self.aspNetUserId = jsonDict["aspNetUserId"] as? String
        self.pictureUrl = jsonDict["pictureUrl"] as? String
        self.fullName = jsonDict["fullName"] as? String
    }
}
