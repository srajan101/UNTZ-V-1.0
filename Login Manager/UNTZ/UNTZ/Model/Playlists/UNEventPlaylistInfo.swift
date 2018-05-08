//
//  UNEventPlaylistInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNEventPlaylistInfo: NSObject {
    var eventPlaylistId  : Int?
    var eventId  : Int?
    var playlistName : String?
    var artistPlaylistTracks = [UNArtistPlaylistTracks]()
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.eventPlaylistId = jsonDict["eventPlaylistId"] as? Int
        self.eventId = jsonDict["eventId"] as? Int
        self.playlistName = jsonDict["name"] as? String
        
        if let artistPlaylistTracksArray = jsonDict["eventPlaylistTracks"] as? Array<Dictionary<String, AnyObject>> {
            for artistPlaylistTracksDict in artistPlaylistTracksArray{
                let artistPlaylistTrackeInfo = UNArtistPlaylistTracks.init(jsonDict: artistPlaylistTracksDict)
                self.artistPlaylistTracks.append(artistPlaylistTrackeInfo)
            }
        }

    }
    

}
