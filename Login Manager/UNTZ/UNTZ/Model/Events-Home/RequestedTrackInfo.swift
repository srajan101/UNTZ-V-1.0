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
    var spotifyTrackUri : String?
    var requestDateTime: String?
    var requestAccepted : Bool?
    var acceptedDateTime : String?
    var isUserAdminOrArtist : Bool?
    var isSongAccepted: Bool?
    var spotifyAlbumImageUri: String?
    var eventTrackArtistsInfoList: [EventTrackArtistsInfo]? = []
    var guestsInfo: UserAccountInfo?
    var currentUserInfo: UserAccountInfo?
    var acceptedByName: String?
    var acceptedByUserId: Int?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.trackID = jsonDict["id"] as? Int
        self.spotifyTrackName = jsonDict["name"] as? String
        self.requestDateTime = jsonDict["requestDateTime"] as? String
        self.acceptedDateTime = jsonDict["acceptedDateTime"] as? String
        self.isUserAdminOrArtist = jsonDict["isUserAdminOrArtist"] as? Bool
        self.isSongAccepted = jsonDict["accepted"] as? Bool
        self.spotifyAlbumImageUri = jsonDict["spotifyAlbumImageUrl"] as? String
        self.spotifyTrackUri = jsonDict["spotifyTrackUri"] as? String
        let acceptedByDict = jsonDict["acceptedBy"] as? Dictionary<String, AnyObject>
        
        if let acceptedByDict = acceptedByDict {
            let acceptedFirstName = acceptedByDict["FirstName"] as? String
            
            let acceptedLastName = acceptedByDict["LastName"] as? String

            acceptedByName = acceptedFirstName! + " " + acceptedLastName!

            acceptedByUserId = acceptedByDict["id"] as? Int
        }
        
        
        if let eventTrackArtistsInfoList = jsonDict["artists"] as? Array<Dictionary<String, AnyObject>> {
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
    
    
}
