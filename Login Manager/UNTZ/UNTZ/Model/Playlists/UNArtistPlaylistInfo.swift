//
//  UNArtistPlaylistInfo.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtistPlaylistInfo: NSObject {
    
    var artistAccountId  : Int?
    var artistPlaylists =  [UNArtistPlaylist]()
    var  artistAccount : UNArtistAccount?
    var hasUserEnabledSpotifyAuth : Bool?
    var spotifyAuthUri: String?
    var currentUserAccount : UNProfileInfo?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.artistAccountId = jsonDict["artistAccountId"] as? Int
        self.hasUserEnabledSpotifyAuth = jsonDict["hasUserEnabledSpotifyAuth"] as? Bool
        self.spotifyAuthUri = jsonDict["spotifyAuthUri"] as? String

        
        let artistAccountDict = jsonDict["artistAccount"] as? Dictionary<String, AnyObject>
        if let artistAccountDic = artistAccountDict {
            self.artistAccount = UNArtistAccount.init(jsonDict: artistAccountDic)
        }
        
        let currentUserAccountDict = jsonDict["currentUserAccount"] as? Dictionary<String, AnyObject>
        if let currentUserAccountDict = currentUserAccountDict {
            self.currentUserAccount = UNProfileInfo.init(jsonDict: currentUserAccountDict)
        }
        
        if let artistPlaylistArray = jsonDict["artistPlaylists"] as? Array<Dictionary<String, AnyObject>> {
            for artistPlaylistDict in artistPlaylistArray{
                let artistPlaylistInfo = UNArtistPlaylist.init(jsonDict: artistPlaylistDict)
                self.artistPlaylists.append(artistPlaylistInfo)
            }
        }
    }
}
