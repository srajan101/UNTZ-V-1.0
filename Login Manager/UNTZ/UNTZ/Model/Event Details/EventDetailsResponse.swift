//
//  EventDetailsResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 03/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class EventDetailsResponse: NSObject {
    var hasUserEnabledSpotifyAuth: Bool?
    var data: Dictionary<String, AnyObject>? = [:]
    //var userEventDetails: UserEventDetails?
    var eventInfo : EventInfo?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.hasUserEnabledSpotifyAuth = jsonDict["hasUserEnabledSpotifyAuth"] as? Bool
        let userEventDict = jsonDict["event"] as? Dictionary<String, AnyObject>
        if let userEventDict = userEventDict {
            self.eventInfo = EventInfo.init(jsonDict: userEventDict)
        }
/*
        let userEventDict = jsonDict["event"] as? Dictionary<String, AnyObject>
        if let userEventDict = userEventDict {
            self.userEventDetails = UserEventDetails.init(jsonDict: userEventDict)
        }
*/
        
    }
    
    /*
    func appendData(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["NumberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["NextIndex"] as? Int
        self.itemsAccountId = jsonDict["NumberOfItemsPerPage"] as? String
        
        if let eventsInfos = jsonDict["Items"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos{
                let eventsInfo = EventInfo.init(jsonDict: eventsInfo)
                self.eventsInfoArray?.append(eventsInfo)
            }
        }
    }
    */
}
