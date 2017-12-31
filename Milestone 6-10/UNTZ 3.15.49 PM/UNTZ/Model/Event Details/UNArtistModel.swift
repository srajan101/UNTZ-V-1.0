//
//  UNArtistModel.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 07/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class UNArtistModel: NSObject {
    var isCurrentUserEventAdmin: Bool?
    var eventArtistDetails = [EventArtistDetails]()
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.isCurrentUserEventAdmin = jsonDict["isCurrentUserEventAdmin"] as? Bool
        
        if let eventArtistsList = jsonDict["artists"] as? Array<Dictionary<String, AnyObject>> {
            for eventArtistsDict in eventArtistsList{
                let eventArtistObj = EventArtistDetails.init(jsonDict: eventArtistsDict)
                eventArtistDetails.append(eventArtistObj)
            }
        }
    }
}
