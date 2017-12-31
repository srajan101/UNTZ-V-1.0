//
//  PicturesInfo.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 17/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public struct PicturesInfo {
    var pictureId: Int?
    var pictureUrl: String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.pictureId = jsonDict["id"] as? Int
        self.pictureUrl = jsonDict["pictureUrl"] as? String
    }
}
