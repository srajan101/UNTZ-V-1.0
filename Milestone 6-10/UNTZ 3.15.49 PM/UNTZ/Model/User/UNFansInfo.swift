//
//  UNFansInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNFansInfo: NSObject {
    var userAccount : UNProfileInfo?
    var fanAccount : UNProfileInfo?
    var userAccountId : Int?
    var fanAccountId : Int?
    var fanSince : String?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        let userAccountDict = jsonDict["userAccount"] as? Dictionary<String, AnyObject>
        
        if let userAccountDict = userAccountDict {
            self.userAccount = UNProfileInfo.init(jsonDict: userAccountDict)
        }
        
        let fanAccountDict = jsonDict["fanAccount"] as? Dictionary<String, AnyObject>
        
        if let fanAccountDict = fanAccountDict {
            self.fanAccount = UNProfileInfo.init(jsonDict: fanAccountDict)
        }
        
        self.fanAccountId = jsonDict["fanAccountId"] as? Int
        self.userAccountId = jsonDict["userAccountId"] as? Int
        self.fanSince = jsonDict["fanSince"] as? String
    }
}
