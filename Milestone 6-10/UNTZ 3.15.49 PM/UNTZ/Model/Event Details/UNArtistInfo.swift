//
//  UNArtistInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 07/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class UNArtistInfo: NSObject {
    var artistId: Int?
    var aspNetUserId: String?
    var facebookUserId: String?
    var pictureUrl: String?
    var userName: String?
    var fullName: String?
    
    var artistAccountId: Int?
    var eventArtistDetails: [UNArtistInfo]?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.artistId = jsonDict["artistId"] as? Int
        self.aspNetUserId = jsonDict["aspNetUserId"] as? String
        self.facebookUserId = jsonDict["facebookUserId"] as? String
        self.pictureUrl = jsonDict["pictureUrl"] as? String
        self.userName = jsonDict["userName"] as? String
        self.fullName = jsonDict["fullName"] as? String
    }
}
