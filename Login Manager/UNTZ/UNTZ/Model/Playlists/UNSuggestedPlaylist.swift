//
//  UNSuggestedPlaylist.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNSuggestedPlaylist: NSObject {
    var artistPlaylistId : Int?
    var artistAccountId : Int?
    var eventId : Int?
    var name : String?
    var artistPlaylistTracks = [UNArtistPlaylistTracks]()
    var artistAccount : UNArtistAccount?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.artistPlaylistId = jsonDict["id"] as? Int
        self.artistAccountId = jsonDict["artistAccountId"] as? Int
        self.eventId = jsonDict["eventId"] as? Int
        self.name = jsonDict["name"] as? String
        
        let artistAccountDict = jsonDict["artistAccount"] as? Dictionary<String, AnyObject>
        if let artistAccountDic = artistAccountDict {
            self.artistAccount = UNArtistAccount.init(jsonDict: artistAccountDic)
        }
        
        if let artistPlaylistTracksArray = jsonDict["tracks"] as? Array<Dictionary<String, AnyObject>> {
            for artistPlaylistTracksDict in artistPlaylistTracksArray{
                let artistPlaylistTrackeInfo = UNArtistPlaylistTracks.init(jsonDict: artistPlaylistTracksDict)
                self.artistPlaylistTracks.append(artistPlaylistTrackeInfo)
            }
        }
    }
}
