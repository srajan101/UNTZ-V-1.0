//
//  EMBaseModel.swift
//  Enmoji
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class EMBaseModel {
    

    var status: String?
    var success: String?
    var message : String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[UNAPIResponseStatusKeys.status] as? String
        self.message = jsonDict[UNAPIResponseStatusKeys.message] as? String
    }
}

class EMResponseModel {
    
    var status: String?
    var success: String?
    var message : String?
    var data : Dictionary<String,AnyObject>?
    var tokenData : Dictionary<String,AnyObject>?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[UNAPIResponseStatusKeys.status] as? String
        self.message = jsonDict[UNAPIResponseStatusKeys.message] as? String
        
        if(self.status == UNAPIResponseStatusKeys.success){
            data = jsonDict[UNAPIResponseStatusKeys.data] as? Dictionary<String,AnyObject>
        }
        
        if jsonDict[UNAPIResponseStatusKeys.tokenData] != nil {
            tokenData = jsonDict[UNAPIResponseStatusKeys.tokenData] as? Dictionary<String,AnyObject>
        }
        
    }
}


