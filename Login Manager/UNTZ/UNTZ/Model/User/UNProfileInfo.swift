//
//  UNProfileInfo.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 11/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNProfileInfo: NSObject {
    var id  : Int?
    var spotifyAuthUri: String?
    var hasUserEnabledSpotifyAuth : Bool?
    var aspNetUserId: String?
    var facebookUserId : String?
    var pictureUrl: String?
    var userName: String?
    var fullName : String?
    var FirstName: String?
    var LastName: String?
    var aboutme : String?
    //var fans: [String:AnyObject]? = [:]
    //var fanof: [String:AnyObject]? = [:]
    var fansCount  : Int?
    var fansOfCount  : Int?
    var userProfileRelationship : UNuserProfileRelationship?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.id = jsonDict["id"] as? Int
        self.spotifyAuthUri = jsonDict["spotifyAuthUri"] as? String
        self.hasUserEnabledSpotifyAuth = jsonDict["hasUserEnabledSpotifyAuth"] as? Bool
        self.aspNetUserId = jsonDict["aspNetUserId"] as? String
        self.facebookUserId = jsonDict["facebookUserId"] as? String
        self.pictureUrl = jsonDict["pictureUrl"] as? String
        self.userName = jsonDict["userName"] as? String
        self.fullName = jsonDict["fullName"] as? String
        self.FirstName = jsonDict["FirstName"] as? String
        self.LastName = jsonDict["LastName"] as? String
        self.aboutme = jsonDict["aboutme"] as? String
        
        if let fansArray = jsonDict["fans"] as? Array<Dictionary<String, AnyObject>> {
            fansCount = fansArray.count
        } else {
            fansCount = 0
        }

        if let fansOfArray = jsonDict["fanof"] as? Array<Dictionary<String, AnyObject>> {
            fansOfCount = fansOfArray.count
        } else {
            fansOfCount = 0
        }
        
        let profileRelationshipDict = jsonDict["userProfileRelationship"] as? Dictionary<String, AnyObject>
        
        if let profileRelationshipDict = profileRelationshipDict {
            self.userProfileRelationship = UNuserProfileRelationship.init(jsonDict: profileRelationshipDict)
        }
 }
}
