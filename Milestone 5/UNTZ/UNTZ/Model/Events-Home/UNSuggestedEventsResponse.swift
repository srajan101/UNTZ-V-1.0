//
//  UNSuggestedEventsResponse.swift
//  UNTZ
//
//  Created by Mahesh on 28/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNSuggestedEventsResponse: NSObject {
    var numberOfItemsPerPage: Int?
    var nextIndex: Int?
    var itemsAccountId: String?
    var data: Dictionary<String, AnyObject>? = [:]
    var eventsInfoArray: [EventInfo]? = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
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

}