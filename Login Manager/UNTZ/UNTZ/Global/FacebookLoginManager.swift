//
//  FacebookLoginManager.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 29/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookLoginManager: NSObject {
    //sharedInstance
    static let sharedInstance = FacebookLoginManager()
    var dict : [String : AnyObject]!
    var isFromEventDetails : Bool?
    
    func startLoginProcess(viewController : UIViewController,isFromEventDetails : Bool) {
        self.isFromEventDetails = isFromEventDetails
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email","user_friends","user_events"], from: viewController) { (result, error) in
            GLOBAL().showLoadingIndicatorWithMessage("")
            if(error != nil){
                //GLOBAL().showAlert(APPLICATION.applicationName, message: "Facing trouble in login!", actions: nil)
                GLOBAL().hideLoadingIndicator()
            }else if(result?.isCancelled)!{
                GLOBAL().hideLoadingIndicator()
                // GLOBAL().showAlert(APPLICATION.applicationName, message: "User has cancelled login!", actions: nil)
                print("USer Canceled Login Flow")
            }else{
                print("Getting profile")
                //print("FB version: \(FBSDKSettings.sdkVersion())")
                print("Facebook Token :  \(String(describing: FBSDKAccessToken.current()?.tokenString))")
                
                UserInfo.sharedInstance.setUserInfoInCache(value: FBSDKAccessToken.current()?.tokenString as AnyObject?, key: UNUserInfoKeys.facebookAccessToken)
                
                self.getFBUserData()
               
                UNTZReqeustManager.sharedInstance.apiFacebookLogin((FBSDKAccessToken.current()?.tokenString)!, provider: "Facebook", completionHandler:{ (feedResponse) -> Void in
                    if let downloadError = feedResponse.error{
                        print(downloadError)
                        GLOBAL().hideLoadingIndicator()
                        //GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                    } else {
                        GLOBAL().hideLoadingIndicator()
                        if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                            self.parseTokenInfo(jsonDict: dictionary)
                            self.registerDeviceToken()
                            if isFromEventDetails {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadEventDetails"), object: self)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: self)
                                
                            } else {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadHomeScreen"), object: self)
                            }
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMenu"), object: self)
                        }
                        
                        print("\(feedResponse)")
                    }
                })
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    let fname = self.dict["first_name"] as? String
                    let lname = self.dict["last_name"] as? String
                    let email = self.dict["email"] as? String
                    let uid = self.dict["id"] as? String
                    if let imageURL = ((self.dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        UserInfo.sharedInstance.setUserInfoInCache(value: imageURL as AnyObject?, key: UNUserInfoKeys.Imageurl)
                    }
                    UserInfo.sharedInstance.setUserInfoInCache(value: fname as AnyObject?, key: UNUserInfoKeys.userFName)
                    UserInfo.sharedInstance.setUserInfoInCache(value: lname as AnyObject?, key: UNUserInfoKeys.userLName)
                    UserInfo.sharedInstance.setUserInfoInCache(value: email as AnyObject?, key: UNUserInfoKeys.emailID)
                    UserInfo.sharedInstance.setUserInfoInCache(value: uid as AnyObject?, key: UNUserInfoKeys.socialId)
                    
                }
            })
        }
    }
    
    func parseTokenInfo(jsonDict: Dictionary<String, AnyObject>) {
        let accessToken = jsonDict["access_token"] as? String
        let tokenExpiresIn = jsonDict["expires_in"] as? Int
        let tokenType = jsonDict["token_type"] as? String
        let refreshToken = jsonDict["refresh_token"] as? String
        let userName = jsonDict["userName"] as? String
        let userId = jsonDict["id"] as? String
        let accountId = jsonDict["accountId"] as? Int
        
        UserInfo.sharedInstance.setUserInfoInCache(value: accessToken as AnyObject?, key: UNUserInfoKeys.accessToken)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenExpiresIn as AnyObject?, key: UNUserInfoKeys.tokenExpiresIn)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenType as AnyObject?, key: UNUserInfoKeys.tokenType)
        UserInfo.sharedInstance.setUserInfoInCache(value: refreshToken as AnyObject?, key: UNUserInfoKeys.refreshToken)
        UserInfo.sharedInstance.setUserInfoInCache(value: userName as AnyObject?, key: UNUserInfoKeys.emailID)
        UserInfo.sharedInstance.setUserInfoInCache(value: userId as AnyObject?, key: UNUserInfoKeys.userID)
        UserInfo.sharedInstance.setUserInfoInCache(value: accountId as AnyObject?, key: UNUserInfoKeys.accountID)
        
    }
    
    func registerDeviceToken(){
        let defaults = UserDefaults.standard
        let deviceToken = defaults.object(forKey: CacheConstants.deviceToken) as? String
        if (deviceToken != nil) {
            UNTZReqeustManager.sharedInstance.apiregisterDeviceToken(token: deviceToken! ) {
                (feedResponse) -> Void in
                if let downloadError = feedResponse.error{
                    print(downloadError)
                    //GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                } else {
                    if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                        let id = dictionary["data"] as! String
                        
                        if id.length > 0 {
                            self.registerDeviceId(id: id)
                        } else {
                            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                        }
                    }
                }
            }
        }
    }
    
    //apiregisterId
    func registerDeviceId(id:String){
        let defaults = UserDefaults.standard
        let deviceToken = defaults.object(forKey: CacheConstants.deviceToken) as? String
        if (deviceToken != nil) {
            UNTZReqeustManager.sharedInstance.apiregisterId(token: deviceToken! , idStr: id) {
                (feedResponse) -> Void in
                if let downloadError = feedResponse.error{
                    print(downloadError)
                    //GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                } else {
                    if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                        let dataValue = dictionary["data"] as! Bool!
                        
                        if dataValue == true {
                            
                        } else {
                            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                        }
                    }
                }
            }
        }
    }
    
    
}
