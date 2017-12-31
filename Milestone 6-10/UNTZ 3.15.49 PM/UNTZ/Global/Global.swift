//
//  Global.swift
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2015 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import ReachabilitySwift

struct APPLICATION
{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static var APP_STATUS_BAR_COLOR = UIColor(red: CGFloat(27.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1)
    static var APP_NAVIGATION_BAR_COLOR = UIColor(red: CGFloat(41.0/255.0), green: CGFloat(48.0/255.0), blue: CGFloat(63.0/255.0), alpha: 1)
    static let applicationName = "UNTZ"
}

struct FONT_FACE {
    
    static var AppleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    static var AppleSDGothicNeoLight = "AppleSDGothicNeo-Light"
    static var AppleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
    static var AppleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"
    static var AppleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"
    static var AppleSDGothicNeoThin = "AppleSDGothicNeo-Thin"
    static var AppleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
    
}

struct MBHUDstatus {
    static var i = 0
}

struct DYNAMICFONTSIZE {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    
    static let IS_IPHONE_6P = UIScreen.main.bounds.height == 736.0
    static let IS_IPHONE_6 = UIScreen.main.bounds.height == 667.0
    static let IS_IPHONE_5  = UIScreen.main.bounds.height == 568.0
    static let IS_IPHONE_4 = UIScreen.main.bounds.height == 480.0
    static let IPAD1_2_H  =  UIScreen.main.bounds.width == 1024.0
    static let IPAD3_H  =  UIScreen.main.bounds.width == 2048.0
    
    static var SCREEN_WIDTH = UIScreen.main.bounds.width
    static var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static var SCALE_FACT_H : CGFloat  = (((IS_IPAD) ? 1.80 : ((IS_IPHONE_6P) ? 1.30 : ((IS_IPHONE_6) ? 1.17 : ((IS_IPHONE_5) ? 1.00 : 1.00)))))
    
    static var SCALE_FACT_FONT : CGFloat  = (((IS_IPAD) ? 1.54 : ((IS_IPHONE_6P) ? 1.10 : ((IS_IPHONE_6) ? 1.00 : ((IS_IPHONE_5) ? 0.85 : 1.00)))))
    
}

struct SegueIdentifier {
    static var loginSegueIdentifier = "loginSegueIdentifier"
}

struct CommonAlertMessages {
    static var underProgressMessage = "Under progress, this feature will be available soon."
}


// For APNS-------------------------------------
struct APNS {
    static var kaps = "aps"
    static var kalert = "alert"
    static var kbody = "body"
    static var kmoduleName = "screen"
    
}
struct AppState {
    static var kBackground = "Background"
    static var kInactive = "Inactive"
    static var kActive = "Active"
    static var kCurrentAppState = "CurrentAppState"
}

struct LocalNotification {
    static var loginNotification = "loginNotification"
    static var changePasswordNotification = "changePasswordNotification"
    static var logoutNotification = "logoutNotification"
    static var deviceRegisteredNotification = "deviceRegisteredNotification"
    static var keyboardTapNotification = "keyboardTapNotification"
    static var ktype = "type"
    static var klocal = "local"
    static var kpush = "push"
    static var knothing = "nothing"
    
}

struct UNTZError{
    static let domain = "CVErrorDomain"
    static let networkCode = -1
    static let userInfoKey = "description"
}

struct EMUserTypes{
    static let socialTypeFacebook = 1
    static let socialTypeGmail = 2
    static let socialTypeNormal = 0
}

struct CacheConstants {
    static let isAppAlreadyLaunchedOnce = "isAppAlreadyLaunchedOnce"
    static let isUserLoggedIn = "isUserLoggedIn"
    static let deviceToken = "deviceToken"
}

struct UNTZAPIRequestKeys {
    static let offset = "offset"
    static let latitude = "lat"
    static let longitude = "lon"
    static let userID = "UserId"
    static let userName = "Name"
    static let searchText = "searchText"
    static let categories = "categories"
    static let password = "Password"
    static let emailID = "Email"
    static let profilePic = "ProfilePic"
    static let versionCode = "versionCode"
    static let versionOne = "1"
    static let getEmojiRequestType = "Type"
    static let getAppId = "AppId"
    static let emojiType = "Emojis"
    static let stickersType = "Stickers"
    static let appIDs = "AppIDs"
    static let CategoryType = "CategoryType"
    static let Page = "Page"
    static let isSocialUser = "isSocialUser"
    static let socialId = "SocialId"
    static let socialType = "SocialType"
    static let devicePushToken = "DevicePushToken"
    static let deviceType = "DeviceType"
    static let normalUser = "0"
    static let socialUser = "1"
    static let deviceTypeIOS = "ios"
    static let oldPassword = "OldPassword"
    static let newPassword = "NewPassword"
    static let enableOrDisableSettings = "EnableOrDisable"
    static let requestTimeOutForNoramlAPIs = 60.0
    static let requestTimeOutForFileUploadAPIs = 240.0
    static let Name = "Name"
    static let Email = "Email"
    static let itemType = "Type"
    static let PhoneNumber = "PhoneNumber"
    static let Subject = "Subject"
    static let Description = "Description"
    static let DevicePushToken = "DevicePushToken"
    static let DeviceType = "DeviceType"
    static let webdata = "webdata"
    static let appAboutUs = "app_about_us"
    static let fbtoken = "Token"
    static let fbprovider = "Provider"
    static let accountId = "accountId"
    static let commentId = "Id"
    static let eventId = "eventid"
    static let guestAccountId = "guestaccountid"
    static let guestAccount = "guestaccount"
    static let comment = "comment"
    static let commenttime = "commenttime"
    static let eventComment = "eventComment"
    static let currentUserAccount = "currentUserAccount"
    static let EventIdParam = "EventId"
    static let EventCommentParam = "Comment"
    static let EventPicturesParam = "Pictures"

}

struct UNAPIResponseStatusKeys {
    static let success = "success"
    static let message = "message"
    static let status = "status"
    static let data = "data"
    static let tokenData = "tokendata"
}

struct UNUserInfoKeys {
    static let userID = "UserId"
    static let userName = "Name"
    static let emailID = "Email"
    static let profilePic = "ProfilePic"
    static let isSocialUser = "isSocialUser"
    static let socialId = "SocialId"
    static let devicePushToken = "DevicePushToken"
    static let deviceType = "DeviceType"
    static let userType = "userType"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let tokenType = "tokenType"
    static let tokenExpiresIn = "tokenExpiresIn"
    static let isUserLoggedIn = "isUserLoggedIn"
    static let isNotificationEnabled = "isNotificationEnabled"
    static let userFName = "Fname"
    static let userLName = "Lname"
    static let Imageurl = "Imageurl"
    
}


class GLOBAL : NSObject {
    
    //sharedInstance
    static let sharedInstance = GLOBAL()
    
    
    let isSimulator = TARGET_OS_SIMULATOR != 0
    
    
    override init() {
        dictionary = Dictionary < String , Any? > ()
    }
    
    var methodTitleNameOptionMenu : String = ""
    
    var dictionary : Dictionary < String , Any? >
    //    var dictionary = Dictionary < String , Any? > ()
    
    
    func getGlobalValue(_ KeyToReturn : String) -> Any? {
        
        if let ReturnValue = dictionary[KeyToReturn]
        {
            return ReturnValue
        }
        return nil
    }
    
    //MARK: - Internet Reachability
    var reachability: Reachability?
    var isInternetReachable : Bool? = false
    
    func setupReachability(_ hostName: String?) {
        
        GLOBAL.sharedInstance.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        
        NotificationCenter.default.addObserver(GLOBAL.sharedInstance, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        
    }
    
    func startNotifier() {
        
        setupReachability("google.com")
        
        print("--- start notifier")
        do {
            try GLOBAL.sharedInstance.reachability?.startNotifier()
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        GLOBAL.sharedInstance.reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        GLOBAL.sharedInstance.reachability = nil
    }
    
    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            GLOBAL.sharedInstance.isInternetReachable = true
        } else {
            GLOBAL.sharedInstance.isInternetReachable = false
        }
    }
            
    //MARK: - Progress HUD
    
    func showLoadingIndicatorWithMessage(_ message : String){
        /*
        let hud = MBProgressHUD.showAdded(to: APPLICATION.appDelegate.window!, animated: true)
        //hud.label.text = message
        hud.label.isHidden = true
        let imageData = NSData(contentsOf: Bundle.main.url(forResource: "animationImg",withExtension: "gif")!)
        hud.customView = UIImageView(image: UIImage.sd_animatedGIF(with: imageData as Data!))
        hud.customView?.backgroundColor = UIColor.clear
         */
        /*
        let positionAnimation = CABasicAnimation(keyPath: "transform.rotation")
        positionAnimation.fromValue = NSNumber.init(floatLiteral: 0)
        positionAnimation.toValue = NSNumber.init(floatLiteral: 2*M_PI)
        positionAnimation.duration = 0.7;
        //positionAnimation.repeatCount = HUGE_VALF
        positionAnimation.isRemovedOnCompletion = false
        hud.customView?.layer .add(positionAnimation, forKey: "Spin")
         */
        let hud = MBProgressHUD.showAdded(to: APPLICATION.appDelegate.window!, animated: true)
        hud.label.text = "Loading..."
        //hud.label.textColor = UIColor.white
        hud.label.isHidden = false
        //let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)

        //hud.customView?.backgroundColor = UIColor.black
        //hud.bezelView.color = UIColor.black
        //hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor;
        //hud.backgroundView.color = UIColor.clear
        hud.mode =  MBProgressHUDMode.indeterminate
        
        hud.show(animated: true)
        
    }
    
    func hideLoadingIndicator(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for:APPLICATION.appDelegate.window! , animated: true)
        }
    }
    
    func showLoadingIndicatorWithMessageAndUserInteraction(_ message : String,view:UIView){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
    }
    
    func hideLoadingIndicatorUserInteraction(_ view:UIView){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for:APPLICATION.appDelegate.window! , animated: true)
        }
    }
   
    //MARK: - App Launch First Time
    
    func isAppLaunchedFirstTime()->Bool{
        let defaults = UserDefaults.standard
        
        let isAppLaunchedFirstTimeValue = defaults.bool(forKey: CacheConstants.isAppAlreadyLaunchedOnce)
        
        if isAppLaunchedFirstTimeValue == false {
            print("App launched first time")
            defaults.set(true, forKey: CacheConstants.isAppAlreadyLaunchedOnce)
            return true
        } else {
            return false
        }
    }
    
    //MARK: is User Logged In
    func isUserLoggedIn()->Bool{
        let isUserLogedIn = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.isUserLoggedIn)
        
        if isUserLogedIn == nil {
            return false
        } else {
            let isUserLoggedInBoolValue = isUserLogedIn as! Bool
            
            if (isUserLoggedInBoolValue) {
                print("User is logged In!")
                return true
            } else {
                print("User is not logged In!")
                return false
            }
        }
    }
 
    
    //MARK: - App Launch First Time Pass save = 1 to marked as Login and save = 0 to logout user
    /*
    func manageUserLoggedIn(_ save : Bool)->Void{
        let defaults = UserDefaults.standard
        
        if save {
            if !defaults.bool(forKey: CacheConstants.isUserLoggedIn) {
                print("Mark User Logged In")
                defaults.set(true, forKey: CacheConstants.isUserLoggedIn)
            }
        } else {
            if !defaults.bool(forKey: CacheConstants.isUserLoggedIn) {
                print("User is not logged in")
            } else {
                print("Mark User Logged Out")
                defaults.set(false, forKey: CacheConstants.isUserLoggedIn)
            }
        }
    }
    */
    // MARK: - Show Alert
    
    func showAlert(_ title:String?, message: String, actions:[UIAlertAction]?)
    {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let actions = actions{
            for action in actions{
                alertViewController.addAction(action)
            }
        }else{
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertViewController.addAction(okAction)
        }
        
        
        DispatchQueue.main.async(execute: {
            APPLICATION.appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        })
        
    }
    
    func showDebugAlert(_ title:String?, message: String, actions:[UIAlertAction]?)
    {
        
        //TODO: Handle #if __DEBUG and #endif for this function
        let alertViewController = UIAlertController(title: "_Debug Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let actions = actions{
            for action in actions{
                alertViewController.addAction(action)
            }
        }else{
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertViewController.addAction(okAction)
        }
        
        APPLICATION.appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    // MARK: - Check for partners apps
    
    func updatePartnerAppInstalledStatus(){
        
        let shared : UserDefaults = UserDefaults.init(suiteName: "group.com.enmoji.MySharedUD")!
        
        var mDictAppList = shared.dictionary(forKey: "k_MyParterApps") ?? [:]
        
        let bundleIdentifier = Bundle.main.bundleIdentifier
        
        mDictAppList[bundleIdentifier!] = true
        
        shared.set(mDictAppList, forKey: "k_MyParterApps")
        
        shared.synchronize()
        
        print("PartnerApp Installed: \(Array(mDictAppList.keys))")
        
        //showDebugAlert(APPLICATION.applicationName, message: "PartnerApp Installed: \(Array(mDictAppList.keys))", actions: nil)
        
    }
    
    func getPartnerAppInstalledList() -> Array<Any>{
        
        let shared : UserDefaults = UserDefaults.init(suiteName: "group.com.enmoji.MySharedUD")!
        
        let mDictAppList = shared.dictionary(forKey: "k_MyParterApps") ?? [:] as Dictionary
        
        var aryAllPartnerAppInstalled = Array(mDictAppList.keys)
        
        print("PartnerApp Installed List: \(aryAllPartnerAppInstalled)")
        
        aryAllPartnerAppInstalled.remove(at: aryAllPartnerAppInstalled.index(of: (Bundle.main.bundleIdentifier! as String))!) //Remove self app identifier
        
        //showDebugAlert(APPLICATION.applicationName, message: "PartnerApp Installed: \(Array(mDictAppList.keys))", actions: nil)
        
        return aryAllPartnerAppInstalled
    }
    
    // MARK: - Get-Set NSUserDefaults Global Value
    func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil){
            defaults.set(ObjectToSave, forKey: KeyToSave)
        }
        defaults.synchronize()
    }
    
    func getUserDefault(KeyToGetValue : String) -> AnyObject?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: KeyToGetValue){
            return name as AnyObject?
        }
        return nil
    }
    
    // MARK: - Share using UIActivityViewController
    func shareText(_ text:String, andImage image: UIImage?, andUrl url: URL?, sourceView: UIView, sourceRect: CGRect) {
        var sharingItems = [Any]()
        if text != "" {
            sharingItems.append(text)
        }
        if image != nil {
            sharingItems.append(image!)
        }
        if url != nil {
            sharingItems.append(url!)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        if activityViewController.responds(to: #selector(getter: UIActivityViewController.popoverPresentationController))
        {  // iOS8 and above
            activityViewController.modalPresentationStyle = .popover
            activityViewController.popoverPresentationController!.sourceRect = sourceRect
            activityViewController.popoverPresentationController!.sourceView = sourceView
        
            activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
                
                // Return if cancelled
                if (!completed) {

                }
            }
        }
        let rootController = sourceView.window!.rootViewController!
        rootController.present(activityViewController, animated: true, completion: {() -> Void in
        })
    }
}

