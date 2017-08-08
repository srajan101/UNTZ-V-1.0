//
//  UNEventFeedPostResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNEventFeedPostResponse: NSObject {
    var eventId: Int?
    var IsUserAuthorizedForFeedPosts: Bool?
    var eventFeedPostListArray: [UnEventFeedPostList]? = []
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.eventId = jsonDict["EventId"] as? Int
        self.IsUserAuthorizedForFeedPosts = jsonDict["IsUserAuthorizedForFeedPosts"] as? Bool

        
        if let eventsInfos = jsonDict["EventFeedPostList"] as? Array<Dictionary<String, AnyObject>> {
            for eventsInfo in eventsInfos
            {
                let eventsInfo = UnEventFeedPostList.init(jsonDict: eventsInfo)
                self.eventFeedPostListArray?.append(eventsInfo)
            }
        }
    }
}
