//
//  UNArtistAccount.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 09/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNArtistAccount: NSObject {
    var id : Int?
    var aspNetUserId: String?
    var facebookUserId: String?
    var pictureUrl: String?
    var userName: String?
    var fullName: String?
    var FirstName: String?
    var LastName: String?
    var aboutme: String?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.id = jsonDict["id"] as? Int
        self.aspNetUserId = jsonDict["aspNetUserId"] as? String
        self.facebookUserId = jsonDict["facebookUserId"] as? String
        self.pictureUrl = jsonDict["pictureUrl"] as? String
        self.userName = jsonDict["userName"] as? String
        self.fullName = jsonDict["fullName"] as? String
        self.FirstName = jsonDict["FirstName"] as? String
        self.LastName = jsonDict["LastName"] as? String
        self.aboutme = jsonDict["aboutme"] as? String
    }
}
