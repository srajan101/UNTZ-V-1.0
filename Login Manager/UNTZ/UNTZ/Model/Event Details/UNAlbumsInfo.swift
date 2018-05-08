//
//  UNAlbumsInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 20/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNAlbumsInfo: NSObject {
    var albumTrackId: Int?
    var albumTrackName: String?
    var albumURI: String?
    var albumImage: String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.albumTrackId = jsonDict["id"] as? Int
        self.albumTrackName = jsonDict["name"] as? String
        self.albumURI = jsonDict["uri"] as? String
        let images = jsonDict["images"] as!  Array<Dictionary<String, AnyObject>>
        if images.count > 0 {
            let albumImageDict = images[1] as Dictionary<String, AnyObject>
            self.albumImage = albumImageDict["url"] as? String
        }
    }
}
