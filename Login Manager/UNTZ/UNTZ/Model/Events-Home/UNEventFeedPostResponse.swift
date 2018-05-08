//
//  UNEventFeedPostResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNEventFeedPostResponse: NSObject {
    var numberOfItemsPerPage: Int?
    var nextIndex: Int?
    var itemsAccountId: String?
    var eventId: Int?
    var IsUserAuthorizedForFeedPosts: Bool?
    var eventFeedPostListArray: [UnEventFeedPostList]? = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.eventId = jsonDict["eventId"] as? Int
        self.IsUserAuthorizedForFeedPosts = jsonDict["isUserAuthorizedForFeedPosts"] as? Bool
        self.numberOfItemsPerPage = jsonDict["numberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["nextIndex"] as? Int
        self.itemsAccountId = jsonDict["itemsAccountId"] as? String
        
        if let eventsInfos = jsonDict["items"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos
            {
                let eventsInfo = UnEventFeedPostList.init(jsonDict: eventsInfo)
                self.eventFeedPostListArray?.append(eventsInfo)
            }
        }
    }
    
    func appendData(jsonDict: Dictionary<String, AnyObject>) {
        
        self.numberOfItemsPerPage = jsonDict["numberOfItemsPerPage"] as? Int
        self.nextIndex = jsonDict["nextIndex"] as? Int
        self.itemsAccountId = jsonDict["itemsAccountId"] as? String
        
        self.eventId = jsonDict["eventId"] as? Int
        self.IsUserAuthorizedForFeedPosts = jsonDict["isUserAuthorizedForFeedPosts"] as? Bool
        
        
        if let eventsInfos = jsonDict["items"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos
            {
                let eventsInfo = UnEventFeedPostList.init(jsonDict: eventsInfo)
                self.eventFeedPostListArray?.append(eventsInfo)
            }
        }
    }
}
