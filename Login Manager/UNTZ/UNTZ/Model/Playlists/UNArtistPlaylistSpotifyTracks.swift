//
//  UNArtistPlaylistSpotifyTracks.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtistPlaylistSpotifyTracks: NSObject {
    var id : Int?
    var artistPlaylistId : Int?
    var spotifyTrackName: String?
    var spotifyTrackId: String?
    var duration : Int?
    var popularity : Int?
    var spotifyTrackHref: String?
    var spotifyTrackPreviewUrl:String?
    var spotifyAlbumId: String?
    var spotifyAlbumName: String?
    var spotifyTrackUri: String?
    var spotifyAlbumUri:String?
    var spotifyAlbumImageUrl:String?
    var artists = [UNArtists]()

    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.id = jsonDict["id"] as? Int
        self.artistPlaylistId = jsonDict["artistPlaylistId"] as? Int
        self.duration = jsonDict["duration"] as? Int
        self.popularity = jsonDict["popularity"] as? Int
        self.spotifyTrackName = jsonDict["spotifyTrackName"] as? String
        self.spotifyTrackId = jsonDict["spotifyTrackId"] as? String
        self.spotifyTrackHref = jsonDict["spotifyTrackHref"] as? String
        self.spotifyTrackPreviewUrl = jsonDict["spotifyTrackPreviewUrl"] as? String
        self.spotifyAlbumId = jsonDict["spotifyAlbumId"] as? String
        self.spotifyAlbumName = jsonDict["spotifyAlbumName"] as? String
        
        if let spotifyTrackUri = jsonDict["spotifyTrackUri"] as? String {
            if spotifyTrackUri.contains("spotify:local") {
                self.spotifyTrackUri = nil
            } else {
                self.spotifyTrackUri = spotifyTrackUri
            }
            
        }
        
        self.spotifyAlbumUri = jsonDict["spotifyAlbumUri"] as? String
        self.spotifyAlbumImageUrl = jsonDict["spotifyAlbumImageUrl"] as? String
        
        if let artistArray = jsonDict["artists"] as? Array<Dictionary<String, AnyObject>> {
            for artistDict in artistArray{
                let artistInfo = UNArtists.init(jsonDict: artistDict)
                self.artists.append(artistInfo)
            }
        }
    }
}
