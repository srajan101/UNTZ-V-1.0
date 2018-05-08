//
//  UNArtists.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtists: NSObject {
    var id : Int?
    var artistPlaylistSpotifyTrackId : Int?
    var suggestedPlaylistTrackId : Int?
    var eventPlaylistTrackId : Int?
    var spotifyArtistId: String?
    var spotifyArtistName: String?
    var spotifyArtistUri: String?
    var spotifyArtistHref: String?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.id = jsonDict["id"] as? Int
        self.artistPlaylistSpotifyTrackId = jsonDict["artistPlaylistSpotifyTrackId"] as? Int
        self.suggestedPlaylistTrackId = jsonDict["suggestedPlaylistTrackId"] as? Int
        self.eventPlaylistTrackId = jsonDict["eventPlaylistTrackId"] as? Int
        self.spotifyArtistId = jsonDict["spotifyArtistId"] as? String
        self.spotifyArtistName = jsonDict["name"] as? String
        self.spotifyArtistUri = jsonDict["spotifyArtistUri"] as? String
        self.spotifyArtistHref = jsonDict["spotifyArtistHref"] as? String

    }
}
