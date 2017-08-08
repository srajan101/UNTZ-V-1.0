//
//  APIEndPoints.swift
//  Enmoji
//
//  Created by Mahesh on 16/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class APIEndPoints {
    
    static func getwebURL() -> String {
        return "https://untz.azurewebsites.net"
    }
    
    static func getBaseURL() -> String {
        return "https://untz.azurewebsites.net/api/"
    }

    static func getEventCategoryURL() -> String {
        return getBaseURL() + "Event/"
    }

    static func getLoginURL() -> String {
        return getEventCategoryURL() + "login"
    }
    
    static func getListOfEventCategories() -> String {
        return getEventCategoryURL() + "Category"
    }
    
    static func getSuggestedEventsList() -> String {
        return getEventCategoryURL() + "SuggestedEvents"
    }
    
    static func getUserEventsList() -> String {
        return getEventCategoryURL() + "UserEvents"
    }
    
    static func postRegFBtoken() -> String {
        return getBaseURL() + "Account/RegisterExternalToken"
    }
    
    static func getEventDetails() -> String {
        return getEventCategoryURL()
    }
    
    static func markAsInterested() -> String {
        return "Interested"
    }
    
    static func markAsNonInterested() -> String {
        return "NotInterested"
    }
    
    static func joinEvent() -> String {
        return "Join"
    }
    
    static func leaveEvent() -> String {
        return "Leave"
    }
    
    static func markEventAsCancel() -> String {
        return "Cancel"
    }
    
    static func markEventAsUnCancel() -> String {
        return "Uncancel"
    }

    static func goLive() -> String {
        return "GoLive"
    }

    static func getCurrentlyPlayingTrack() -> String {
        return "CurrentlyPlayingTrack"
    }

    static func getArtistList() -> String {
        return "Artist"
    }
    
    static func importFacebookEvent() -> String {
        return "ImportFacebookEvent"
    }
    
    static func addFacebookUserAsArtist() -> String {
        return "AddFacebookUserAsArtist"
    }
    
    static func importFacebookUser() -> String {
        return "ImportFacebookUser"
    }
    
    static func feedPost() -> String {
        return "FeedPost"
    }
    
    static func performOnRequestedTrack() -> String {
        return "RequestedTrack"
    }

    static func pictureComment() -> String {
        return "PictureComment"
    }

}
