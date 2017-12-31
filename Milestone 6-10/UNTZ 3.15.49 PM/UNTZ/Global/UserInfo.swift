//
//  UserInfo.swift
//  Enmoji
//
//  Created by Mahesh on 22/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

class UserInfo : NSObject {
    
    static let sharedInstance = UserInfo()

    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Get-Set NSUserDefaults Global Value
    func setUserInfoInCache(value : AnyObject?  , key : String)
    {
        let defaults = UserDefaults.standard
        
        if (value != nil){
            defaults.set(value, forKey: key)
        }
        defaults.synchronize()
    }
    
    func getUserDefault(key : String) -> AnyObject?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: key){
            return name as AnyObject?
        }
        return nil
    }
    
    func removeCacheValue(key : String)
    {
        let defaults = UserDefaults.standard
        
        if defaults.value(forKey: key) != nil{
            defaults.removeObject(forKey: key)
        }
    }
    
    func clearUserInfoWhenUserLoggedOut() {
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.userID)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.userName)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.profilePic)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.emailID)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.socialId)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.userType)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.userID)
        
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.accessToken)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.refreshToken)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.tokenExpiresIn)
        UserInfo.sharedInstance.removeCacheValue(key: UNUserInfoKeys.tokenType)
        
        UserInfo.sharedInstance.setUserInfoInCache(value: false as AnyObject?, key: UNUserInfoKeys.isUserLoggedIn)
        
    }
}
