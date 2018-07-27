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
        //return "https://untz.azurewebsites.net"
        return "https://untzhub.com"
    }
    
    static func getBaseURL() -> String {
        //return "https://untz.azurewebsites.net/api/"
        return "https://untzhub.com/api/"
    }

    static func getEventCategoryURL() -> String {
        return getBaseURL() + "Event/"
    }
    static func registerDevice() -> String {
        return getBaseURL() + "Register"
    }
    static func registerId() -> String {
        return getBaseURL() + "Register/"
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
    static func getPastEventsList() -> String {
        return getEventCategoryURL() + "UserPastEvents"
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
    
    static func getProfileURL() -> String {
        return getBaseURL() + "Profile/"
    }
    
    static func searchSpotifySongs() -> String {
        return getBaseURL() + "Spotify/Search"
    }

    static func registerSpotifyAccessToken() -> String {
        return getBaseURL() + "Spotify/AccessToken"
    }
    
    static func getUpdateAboutMeURL() -> String {
        return getBaseURL() + "Profile/UpdateAboutMe"
    }
    
    static func getNotificationListURL() -> String {
        return getBaseURL() + "Notifications/List"
    }
    
    static func getFacebookUserEventsURL() -> String {
        return getEventCategoryURL() + "ImportFacebookUserEvents"
    }
    
    static func getFansURL() -> String {
        return "Fans"
    }
    static func getPlaylistURL() -> String {
        return "Playlist"
    }
    static func getPlaylistTrackURL() -> String {
        return "PlaylistTrack"
    }
    
    static func getFansOfURL() -> String {
        return "FanOf"
    }
    static func getBecomeFanURL() -> String {
        return "BecomeFan"
    }
    static func getUnfanURL() -> String {
        return "Unfan"
    }
    
    static func addRequestedTrackURL() -> String {
        return "AddRequestedTrack"
    }
    
    static func eventPlaylistTrackURL() -> String {
        return "EventPlaylistTrack"
    }
    
    static func votePlaylistTrackURL() -> String {
        return "Vote"
    }
    
    static func unVotePlaylistTrackURL() -> String {
        return "Unvote"
    }
    
    static func suggestedPlaylistURL() -> String {
        return "SuggestedPlaylist"
    }
    
    static func addSuggestedPlaylistTrackURL() -> String {
        return "AddSuggestedPlaylistTrack"
    }
    
    static func suggestedPlaylistTrackURL() -> String {
        return "SuggestedPlaylistTrack"
    }
    
}