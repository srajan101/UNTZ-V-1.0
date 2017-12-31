//
//  UserEventStatus.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 03/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public struct UserEventStatus {
    var eventId: Int?
    var rsvpStatus: String?
    var isUserInterested = false
    var isUserJoined = false
    var isUserAdmin = false
    var isUserArtist = false
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.eventId = jsonDict["eventId"] as? Int
        self.rsvpStatus = jsonDict["rsvpStatus"] as? String
        //self.isUserInterested = jsonDict["isUserInterested"] as? Bool
        
        if let rsvpStatus = self.rsvpStatus {
            if rsvpStatus == "interested" {
                self.isUserInterested = true
            }
            else if rsvpStatus == "joined" {
                self.isUserJoined = true
                self.isUserInterested = true
            }
        }
        self.isUserAdmin = (jsonDict["isUserAdmin"] as? Bool)!
        self.isUserArtist = (jsonDict["isUserArtist"] as? Bool)!
    }
}
