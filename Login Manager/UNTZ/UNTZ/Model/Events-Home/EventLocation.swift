//
//  EventLocation.swift
//  UNTZ
//
//  Created by Mahesh on 28/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class EventLocation: NSObject {

    var locationId: Int?
    var locationName: String?
    var facebookid: String?
    var distanceFromDeviceLocation : Double?
    var city: String?
    var country: String?
    var state: String?
    var street: String?
    var zip: String?
    var latitude: Double?
    var longitude: Double?
    
    override init() {}
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.locationId = jsonDict["id"] as? Int
        self.facebookid = jsonDict["facebookId"] as? String
        self.locationName = jsonDict["name"] as? String
        self.distanceFromDeviceLocation = jsonDict["distanceFromDeviceLocation"] as? Double ?? 0.0
        self.city = jsonDict["city"] as? String
        self.country = jsonDict["country"] as? String
        self.state = jsonDict["state"] as? String
        self.street = jsonDict["street"] as? String
        self.zip = jsonDict["zip"] as? String
        self.latitude = jsonDict["ipadBigImage"] as? Double
        self.longitude = jsonDict["iphoneBigImage"] as? Double
    }
    
}
