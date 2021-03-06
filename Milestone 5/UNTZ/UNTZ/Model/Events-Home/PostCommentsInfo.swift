//
//  PostCommentsInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PostCommentsInfo: NSObject {

    var commentID: Int?
    var commentName: String?
    var commentTime: String?
    var picturesInfoListArray: [PicturesInfo]? = []
    var guestsInfo: UserAccountInfo?

    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.commentID = jsonDict["Id"] as? Int
        self.commentName = jsonDict["comment"] as? String
        self.commentTime = jsonDict["commenttime"] as? String
        
        if let picturesInfoList = jsonDict["pictures"] as? Array<Dictionary<String, AnyObject>> {
            for pictInfo in picturesInfoList
            {
                let pictInfoObj = PicturesInfo.init(jsonDict: pictInfo)
                self.picturesInfoListArray?.append(pictInfoObj)
            }
        }
        
        let guestAccountDict = jsonDict["guestaccount"] as? Dictionary<String, AnyObject>
        
        if let guestAccountDict = guestAccountDict {
            self.guestsInfo = UserAccountInfo.init(jsonDict: guestAccountDict)
        }

    }
    
    struct PicturesInfo {
        var pictureId: Int?
        var pictureUrl: String?
        
        init(jsonDict: Dictionary<String, AnyObject>) {
            self.pictureId = jsonDict["id"] as? Int
            self.pictureUrl = jsonDict["pictureUrl"] as? String
        }
    }    
}
