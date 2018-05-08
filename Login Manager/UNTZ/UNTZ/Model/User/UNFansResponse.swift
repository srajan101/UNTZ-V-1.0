//
//  UNFansResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNFansResponse: NSObject {
    var profileAccount : UNProfileInfo?
    var fansList =  [UNFansInfo]()
    var currentUserAccount : UNProfileInfo?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        let profileAccountDict = jsonDict["profileAccount"] as? Dictionary<String, AnyObject>
        
        if let profileAccountDict = profileAccountDict {
            self.profileAccount = UNProfileInfo.init(jsonDict: profileAccountDict)
        }

        let currentUserAccountDict = jsonDict["currentUserAccount"] as? Dictionary<String, AnyObject>
        
        if let currentUserAccountDict = currentUserAccountDict {
            self.currentUserAccount = UNProfileInfo.init(jsonDict: currentUserAccountDict)
        }

        if let fansArray = jsonDict["fans"] as? Array<Dictionary<String, AnyObject>> {
            for fanDict in fansArray{
                let fansInfo = UNFansInfo.init(jsonDict: fanDict)
                self.fansList.append(fansInfo)
            }
        }
    }
}
