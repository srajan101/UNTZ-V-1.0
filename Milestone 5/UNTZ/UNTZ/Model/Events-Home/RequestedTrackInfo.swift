//
//  RequestedTrackInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class RequestedTrackInfo: NSObject {

    var trackID: Int?
    var spotifyTrackName: String?
    var requestDateTime: String?
    var requestAccepted : Bool?
    var acceptedDateTime : String?
    var isUserAdminOrArtist : Bool?
    var isSongAccepted: Bool?
    var spotifyAlbumImageUri: String?
    var eventTrackArtistsInfoList: [EventTrackArtistsInfo]? = []
    var guestsInfo: UserAccountInfo?
    var currentUserInfo: UserAccountInfo?

    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.trackID = jsonDict["id"] as? Int
        self.spotifyTrackName = jsonDict["spotifyTrackName"] as? String
        self.requestDateTime = jsonDict["requestDateTime"] as? String
        self.acceptedDateTime = jsonDict["acceptedDateTime"] as? String
        self.isUserAdminOrArtist = jsonDict["isUserAdminOrArtist"] as? Bool
        self.isSongAccepted = jsonDict["accepted"] as? Bool
        self.spotifyAlbumImageUri = jsonDict["spotifyAlbumImageUri"] as? String
        
        if let eventTrackArtistsInfoList = jsonDict["eventTrackArtists"] as? Array<Dictionary<String, AnyObject>> {
            for eventTrackArtistsInfo in eventTrackArtistsInfoList
            {
                let eventTrackArtistsInfo = EventTrackArtistsInfo.init(jsonDict: eventTrackArtistsInfo)
                self.eventTrackArtistsInfoList?.append(eventTrackArtistsInfo)
            }
        }
        
        let guestAccountDict = jsonDict["requestorAccount"] as? Dictionary<String, AnyObject>
        
        if let guestAccountDict = guestAccountDict {
            self.guestsInfo = UserAccountInfo.init(jsonDict: guestAccountDict)
        }

        let currentUserAccountDict = jsonDict["currentUserAccount"] as? Dictionary<String, AnyObject>
        
        if let currentUserAccountDict = currentUserAccountDict {
            self.currentUserInfo = UserAccountInfo.init(jsonDict: currentUserAccountDict)
        }

    }
    
    struct EventTrackArtistsInfo {
        var eventTrackId: Int?
        var eventTrackName: String?
        var eventURI: String?
        var eventHREF: String?
        
        init(jsonDict: Dictionary<String, AnyObject>) {
            self.eventTrackId = jsonDict["id"] as? Int
            self.eventTrackName = jsonDict["name"] as? String
            self.eventURI = jsonDict["uri"] as? String
            self.eventHREF = jsonDict["href"] as? String
        }
    }
}
