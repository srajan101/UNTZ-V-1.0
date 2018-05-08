//
//  UnEventFeedPostList.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UnEventFeedPostList: NSObject {
    var postCommentsInfo : PostCommentsInfo?
    var requestedTrackInfo : RequestedTrackInfo?
    var eventFeedPostId: Int?
    var guestAccountId: Int?
    var eventCommentId: Int?
    var eventRequestedTrackId: Int?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        let userEventDict = jsonDict["eventComment"] as? Dictionary<String, AnyObject>
        
        if let userEventDict = userEventDict {
            self.postCommentsInfo = PostCommentsInfo.init(jsonDict: userEventDict)
        }
        
        let requestedTrackInfoDict = jsonDict["eventRequestedTrack"] as? Dictionary<String, AnyObject>
        
        if let requestedTrackInfoDict = requestedTrackInfoDict {
            self.requestedTrackInfo = RequestedTrackInfo.init(jsonDict: requestedTrackInfoDict)
        }
        
        self.eventFeedPostId = jsonDict["id"] as? Int
        self.guestAccountId = jsonDict["guestAccountId"] as? Int
        self.eventCommentId = jsonDict["eventCommentId"] as? Int
        self.eventRequestedTrackId = jsonDict["eventRequestedTrackId"] as? Int
    }
}
