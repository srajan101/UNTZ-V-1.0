//
//  UNUpcomingEventsResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 21/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNUpcomingEventsResponse: NSObject {
    var numberOfItemsPerPage: Int?
    var nextIndex: Int?
    var itemsAccountId: String?
    var data: Dictionary<String, AnyObject>? = [:]
    var eventsInfoArray: [UserEventDetails]? = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["NumberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["NextIndex"] as? Int
        self.itemsAccountId = jsonDict["NumberOfItemsPerPage"] as? String
        
        if let eventsInfos = jsonDict["Items"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos{
                let eventsInfo = UserEventDetails.init(jsonDict: eventsInfo)
                self.eventsInfoArray?.append(eventsInfo)
            }
        }
    }
    
    func appendData(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["NumberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["NextIndex"] as? Int
        self.itemsAccountId = jsonDict["NumberOfItemsPerPage"] as? String
        
        if let eventsInfos = jsonDict["Items"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos{
                let eventsInfo = UserEventDetails.init(jsonDict: eventsInfo)
                self.eventsInfoArray?.append(eventsInfo)
            }
        }
    }

    
}
