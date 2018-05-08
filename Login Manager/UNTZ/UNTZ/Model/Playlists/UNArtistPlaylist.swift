//
//  UNArtistPlaylist.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtistPlaylist: NSObject {

   var artistPlaylistId : Int?
   var artistAccountId : Int?
   var name : String?
    var artistPlaylistTracks = [UNArtistPlaylistTracks]()
    var artistPlaylistSpotifyTracks =  [UNArtistPlaylistSpotifyTracks]()
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.artistPlaylistId = jsonDict["artistPlaylistId"] as? Int
        self.artistAccountId = jsonDict["artistAccountId"] as? Int
        self.name = jsonDict["name"] as? String

        if let artistPlaylistTracksArray = jsonDict["artistPlaylists"] as? Array<Dictionary<String, AnyObject>> {
            for artistPlaylistTracksDict in artistPlaylistTracksArray{
                let artistPlaylistTrackeInfo = UNArtistPlaylistTracks.init(jsonDict: artistPlaylistTracksDict)
                self.artistPlaylistTracks.append(artistPlaylistTrackeInfo)
            }
        }
        
        if let artistPlaylistSpotifyTracksArray = jsonDict["artistPlaylistSpotifyTracks"] as? Array<Dictionary<String, AnyObject>> {
            for artistPlaylistSpotifyDict in artistPlaylistSpotifyTracksArray{
                let artistPlaylistSpotifyTrackeInfo = UNArtistPlaylistSpotifyTracks.init(jsonDict: artistPlaylistSpotifyDict)
             self.artistPlaylistSpotifyTracks.append(artistPlaylistSpotifyTrackeInfo)
            }
        }
    }
}
