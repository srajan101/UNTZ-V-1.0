//
//  EventArtistDetails.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 07/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class EventArtistDetails: NSObject {
    var eventArtistId: Int?
    var eventId: Int?
    var artistAccountId: Int?
    var artistInfo: UNArtistInfo?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.eventArtistId = jsonDict["eventArtistId"] as? Int
        self.eventId = jsonDict["eventId"] as? Int
        self.artistAccountId = jsonDict["artistAccountId"] as? Int
        
        if let artistInfoData = jsonDict["artistAccount"] as? Dictionary<String, AnyObject> {
            artistInfo = UNArtistInfo.init(jsonDict: artistInfoData)
        }

    }
}
