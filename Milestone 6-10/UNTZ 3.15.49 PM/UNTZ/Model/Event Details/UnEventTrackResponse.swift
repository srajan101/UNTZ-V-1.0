//
//  UnEventTrackResponse.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 08/08/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UnEventTrackResponse: NSObject {
    var requestedTrackInfoList : [RequestedTrackInfo] = []
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        if let requestedTrackInfoList = jsonDict["eventTrackRequests"] as? Array<Dictionary<String, AnyObject>> {
            for requestedTrackInfoDict in requestedTrackInfoList{
                let requestedTrackInfo = RequestedTrackInfo.init(jsonDict: requestedTrackInfoDict)
                self.requestedTrackInfoList.append(requestedTrackInfo)
            }
        }
    }
}
