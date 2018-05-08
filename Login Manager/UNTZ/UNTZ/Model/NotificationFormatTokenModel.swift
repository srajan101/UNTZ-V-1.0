//
//  NotificationFormatTokenModel.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 14/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class NotificationFormatTokenModel: NSObject {
    var actorUserId  : Int?
    var actorName: String?
    var requestorName : String?
    var actorPictureUrl: String?
    var requestorUserId : Int?
    var artistName: String?
    var artistUserId: Int?
    var songName : String?
    var songArtistName: String?
    var playlistName: String?
    var eventName : String?
    var eventStartDate : String?
    var oldPlaylistName : String?
    var newPlaylistName : String?
    var destinationUrl : String?
    var entityViewName : String?
    var entityId  : Int?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.actorUserId = jsonDict["actorUserId"] as? Int
        self.actorName = jsonDict["actorName"] as? String
        self.requestorName = jsonDict["requestorName"] as? String
        self.actorPictureUrl = jsonDict["actorPictureUrl"] as? String
        self.requestorUserId = jsonDict["requestorUserId"] as? Int
        self.artistName = jsonDict["artistName"] as? String
        self.artistUserId = jsonDict["artistUserId"] as? Int
        self.songName = jsonDict["songName"] as? String
        self.songArtistName = jsonDict["songArtistName"] as? String
        self.playlistName = jsonDict["playlistName"] as? String
        self.eventName = jsonDict["eventName"] as? String
        self.eventStartDate = jsonDict["eventStartDate"] as? String
        self.oldPlaylistName = jsonDict["oldPlaylistName"] as? String
        self.newPlaylistName = jsonDict["newPlaylistName"] as? String
        self.destinationUrl = jsonDict["destinationUrl"] as? String
        
        
        let appDestination = jsonDict["appDestination"] as? Dictionary<String, AnyObject>
        
        if let appDestination = appDestination {
            self.entityViewName = appDestination["entityViewName"] as? String
            self.entityId = appDestination["entityId"] as? Int
        }
    }
}
