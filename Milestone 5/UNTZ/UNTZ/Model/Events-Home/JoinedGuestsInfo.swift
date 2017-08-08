//
//  JoinedGuestsInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 21/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class JoinedGuestsInfo: NSObject {

    var id: Int?
    var eventId : Int?
    var guestsInfo: GuestsInfo?
    
    override init() {}
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.id = jsonDict["Id"] as? Int
        self.eventId = jsonDict["EventId"] as? Int
        
        let guestAccountDict = jsonDict["GuestAccount"] as? Dictionary<String, AnyObject>

        if let guestAccountDict = guestAccountDict {
            self.guestsInfo = GuestsInfo.init(jsonDict: guestAccountDict)
        }
    }
    
    struct GuestsInfo {
        var guestId: Int?
        var aspNetUserId: String?
        var facebookUserId: String?
        var pictureUrl: String?
        var userName: String?
        var fullName: String?
        
        init(jsonDict: Dictionary<String, AnyObject>) {
            self.guestId = jsonDict["Id"] as? Int
            self.facebookUserId = jsonDict["facebookUserId"] as? String
            self.userName = jsonDict["userName"] as? String
            self.aspNetUserId = jsonDict["aspNetUserId"] as? String
            self.pictureUrl = jsonDict["pictureUrl"] as? String
            self.fullName = jsonDict["fullName"] as? String
        }
    }
}
