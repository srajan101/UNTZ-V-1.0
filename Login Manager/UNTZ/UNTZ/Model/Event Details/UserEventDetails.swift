//
//  UserEventDetails.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 03/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class UserEventDetails: NSObject {
    
    var eventInfo : EventInfo?
    var isUserAdmin: Bool?
    var isUserArtist: Bool?
    var isUserInterested: Bool?
    var isUserJoined: Bool?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        let userEventDict = jsonDict["event"] as? Dictionary<String, AnyObject>
        if let userEventDict = userEventDict {
            self.eventInfo = EventInfo.init(jsonDict: userEventDict)
        }

        self.isUserAdmin = jsonDict["IsUserAdmin"] as? Bool
        self.isUserArtist = jsonDict["IsUserArtist"] as? Bool
        self.isUserInterested = jsonDict["IsUserInterested"] as? Bool
        self.isUserJoined = jsonDict["IsUserJoined"] as? Bool
    }
    
}
