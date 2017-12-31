//
//  UNSpotifyTrackItemsInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 20/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class UNSpotifyTrackItemsInfo : NSObject {
    
    var jsonReponse: String?
    var jsonReponseDict: [String:AnyObject]?
    var trackID: Int?
    var spotifyTrackName: String?
    var popularity : Int?
    var duration : CUnsignedLong?
    var spotifyTrackUri: String?
    var previewURL : String?
    var spotifyTrackArtistsInfoList: [EventTrackArtistsInfo]? = []
    var albumsInfo: UNAlbumsInfo?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            self.jsonReponse = String.init(data: jsonData, encoding: String.Encoding.utf8)
        } catch let myJSONError {
            print(myJSONError)
            self.jsonReponse = nil
        }
        
        if let data = self.jsonReponse?.data(using: .utf8) {
            do {
                self.jsonReponseDict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.trackID = jsonDict["id"] as? Int
        self.spotifyTrackName = jsonDict["name"] as? String
        self.popularity = jsonDict["popularity"] as? Int
        self.duration = jsonDict["duration_ms"] as? CUnsignedLong
        self.spotifyTrackUri = jsonDict["uri"] as? String
        self.previewURL = jsonDict["preview_url"] as? String
        
        if let eventTrackArtistsInfoList = jsonDict["artists"] as? Array<Dictionary<String, AnyObject>> {
            for eventTrackArtistsInfo in eventTrackArtistsInfoList
            {
                let spotifyTrackArtistsInfo = EventTrackArtistsInfo.init(jsonDict: eventTrackArtistsInfo)
                self.spotifyTrackArtistsInfoList?.append(spotifyTrackArtistsInfo)
            }
        }
        
        let albumsInfoDict = jsonDict["album"] as? Dictionary<String, AnyObject>
        
        if let albumsInfoDict = albumsInfoDict {
            self.albumsInfo = UNAlbumsInfo.init(jsonDict: albumsInfoDict)
        }
    }
}
