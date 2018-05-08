//
//  UNUserVotes.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 16/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNUserVotes: NSObject {
    var id : Int?
    var votingAccountId : Int?
    var suggestedPlaylistTrackId : Int?
    var eventPlaylistTrackId : Int?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.id = jsonDict["id"] as? Int
        self.votingAccountId = jsonDict["votingAccountId"] as? Int
        self.suggestedPlaylistTrackId = jsonDict["suggestedPlaylistTrackId"] as? Int
        self.eventPlaylistTrackId = jsonDict["eventPlaylistTrackId"] as? Int

    }
}
