//
//  EventTrackArtistsInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 20/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public struct EventTrackArtistsInfo {
    var eventTrackId: Int?
    var eventRequestedTrackId : Int?
    var eventTrackName: String?
    var eventURI: String?
    var eventHREF: String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.eventTrackId = jsonDict["id"] as? Int
        self.eventRequestedTrackId = jsonDict["eventRequestedTrackId"] as? Int
        
        if let name = jsonDict["name"] as? String {
            self.eventTrackName = name
        }
        else if let name = jsonDict["Name"] as? String {
            self.eventTrackName = name
        }

        self.eventURI = jsonDict["spotifyArtistUri"] as? String
        self.eventHREF = jsonDict["spotifyArtistHref"] as? String
    }
}
