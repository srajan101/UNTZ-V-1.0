//
//  UNSpotifyTracksInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 20/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class UNSpotifyTracksInfo : NSObject {
    var spotifyTrackList : [UNSpotifyTrackItemsInfo] = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        let tracksDict = jsonDict["tracks"] as? Dictionary<String, AnyObject>
        
        if let trackItems = tracksDict!["items"] as? Array<Dictionary<String, AnyObject>> {
            for requestedTrackInfoDict in trackItems {
                let requestedTrackInfo = UNSpotifyTrackItemsInfo.init(jsonDict: requestedTrackInfoDict)
                self.spotifyTrackList.append(requestedTrackInfo)
            }
        }

    }
}
