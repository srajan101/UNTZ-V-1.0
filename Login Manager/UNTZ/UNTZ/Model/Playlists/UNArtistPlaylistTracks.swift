//
//  UNArtistPlaylistTracks.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtistPlaylistTracks: NSObject {

   var id : Int?
   var suggestedPlaylistId : Int?
    var eventPlaylistId : Int?
   var artistPlaylistId : Int?
   var name: String?
   var label: String?
   var artist: String?
   var remixer: String?
   var duration : Int?
   var bpm : Int?
   var labelValue : String?
   var genre: String?
   var imageUrl: String?
   var spotifyTrackUri: String?
   var artists = [UNArtists]()
   var votes = [UNUserVotes]()
   var voteCnt : Int?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.id = jsonDict["id"] as? Int
        self.suggestedPlaylistId = jsonDict["suggestedPlaylistId"] as? Int
        self.eventPlaylistId = jsonDict["eventPlaylistId"] as? Int
        self.artistPlaylistId = jsonDict["artistPlaylistId"] as? Int
        self.duration = jsonDict["duration"] as? Int
        self.bpm = jsonDict["bpm"] as? Int
        self.name = jsonDict["name"] as? String
        self.labelValue = jsonDict["label"] as? String
        self.artist = jsonDict["artist"] as? String
        self.remixer = jsonDict["remixer"] as? String
        self.genre = jsonDict["genre"] as? String
        self.imageUrl = jsonDict["spotifyAlbumImageUrl"] as? String
        //self.spotifyTrackUri = jsonDict["spotifyTrackUri"] as? String
        
        if let spotifyTrackUri = jsonDict["spotifyTrackUri"] as? String {
            if spotifyTrackUri.contains("spotify:local") {
                self.spotifyTrackUri = nil
            } else {
                self.spotifyTrackUri = spotifyTrackUri
            }
            
        }
        self.voteCnt = 0 
        
        if let artistArray = jsonDict["artists"] as? Array<Dictionary<String, AnyObject>> {
            for artistDict in artistArray{
                let artistInfo = UNArtists.init(jsonDict: artistDict)
                self.artists.append(artistInfo)
            }
        }
        
        if let votesArray = jsonDict["votes"] as? Array<Dictionary<String, AnyObject>> {
            for votesDict in votesArray{
                let votesInfo = UNUserVotes.init(jsonDict: votesDict)
                self.votes.append(votesInfo)
            }
            self.voteCnt = votesArray.count;
        }
 }
}
