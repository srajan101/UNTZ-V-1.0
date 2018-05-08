//
//  UNuserProfileRelationship.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 20/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNuserProfileRelationship: NSObject {
    var isUsersOwnProfile: Bool?
    var isCurrentUserFanOfProfile : Bool?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.isCurrentUserFanOfProfile = jsonDict["isCurrentUserFanOfProfile"] as? Bool
        self.isUsersOwnProfile = jsonDict["isUsersOwnProfile"] as? Bool
    }
}
