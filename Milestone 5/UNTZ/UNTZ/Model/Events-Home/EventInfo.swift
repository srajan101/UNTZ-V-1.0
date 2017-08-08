//
//  UNSuggestedEventsResponse.swift
//  UNTZ
//
//  Created by Mahesh on 28/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class EventInfo: NSObject {

    var eventId: Int?
    var eventName: String?
    var facebookid: String?
    var distanceFromDeviceLocation : Double?
    var eventLocation : EventLocation?
    var joinedGuestsInfoArray : [JoinedGuestsInfo]? = []
    var eventAdminsArray: [EventAdmins]? = []
    var eventDescription: String?
    var category: String?
    var type: String?
    var imageurl: String?
    var facebookAttendingCount: Int?
    var facebookInterestedCount: Int?
    var dateTimeStart: String?
    var dateTimeEnd: String?
    var cancelDateTime: String?
    var islivedatetime: String?
    var islive: Bool?
    var isCancelled: Bool?
    var isUserAdmin: Bool?
    var isUserArtist: Bool?
    var isUserInterested: Bool?
    var isUserJoined: Bool?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.eventId = jsonDict["Id"] as? Int
        self.eventName = jsonDict["name"] as? String
        self.facebookid = jsonDict["facebookid"] as? String
        if let distance = jsonDict["distanceFromDeviceLocation"] {
            self.distanceFromDeviceLocation = distance as? Double
        } else {
            self.distanceFromDeviceLocation = 0.0
        }
        //self.distanceFromDeviceLocation = jsonDict["distanceFromDeviceLocation"] as? Double ?? 0.0
        self.eventDescription = jsonDict["description"] as? String
        self.imageurl = jsonDict["imageurl"] as? String
        self.dateTimeStart = jsonDict["dateTimeStart"] as? String
        self.dateTimeEnd = jsonDict["dateTimeEnd"] as? String
        self.cancelDateTime = jsonDict["cancelDateTime"] as? String
        self.islivedatetime = jsonDict["islivedatetime"] as? String
        self.facebookAttendingCount = jsonDict["facebookAttendingCount"] as? Int
        self.facebookInterestedCount = jsonDict["facebookInterestedCount"] as? Int
        self.islive = jsonDict["islive"] as? Bool
        self.isCancelled = jsonDict["isCancelled"] as? Bool
        self.category = jsonDict["category"] as? String

        
        let eventLocationDict = jsonDict["eventLocation"] as? Dictionary<String, AnyObject>
        
        if let eventLocationDict = eventLocationDict {
            self.eventLocation = EventLocation.init(jsonDict: eventLocationDict)
        }
        
        if let eventsInfos = jsonDict["eventAdmins"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos{
                let eventAdmin = EventAdmins.init(jsonDict: eventsInfo)
                self.eventAdminsArray?.append(eventAdmin)
            }
        }
        
        if let joinedGuestsInfos = jsonDict["joinedGuests"] as? Array<Dictionary<String, AnyObject>> {
            for joinedGuestsInfo in joinedGuestsInfos{
                let joinedGuestsInfo = JoinedGuestsInfo.init(jsonDict: joinedGuestsInfo)
                self.joinedGuestsInfoArray?.append(joinedGuestsInfo)
            }
        }


    }
    
    struct EventAdmins {
        var facebookUserId: String?
        var adminName: String?
        
        init(jsonDict: Dictionary<String, AnyObject>) {
            self.facebookUserId = jsonDict["FacebookUserId"] as? String
            self.adminName = jsonDict["Name"] as? String
        }
    }
}
