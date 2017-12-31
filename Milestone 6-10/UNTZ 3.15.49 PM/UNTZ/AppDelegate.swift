//
//  AppDelegate.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IDViewController")
        
        
        //let viewController: UIViewController = ViewController()
        
        let navigationController = NavigationController(rootViewController: viewController)
        let mainViewController = MainViewController()
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(0))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = .white
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()
        
        //Internet reachability
        GLOBAL().startNotifier()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 190/255, green: 20/255, blue: 17/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        

        // iOS 10 support
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    /*func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("URL : \(url)")
        if(url.scheme!.isEqual("fb1831890057054527")) {
            print("Facebook url scheme")
            
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        } else {
            if let sourceApplication = options[.sourceApplication] {
                if (String(describing: sourceApplication) == "com.apple.SafariViewService") {
                    return SpotifyLoginManager.shared.handled(url: url)
                }
            }
        }
        // Called when APNs has assigned the device a unique token
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print("APNs registration failed: \(deviceTokenString)")
            let defaults = UserDefaults.standard
            defaults.set(deviceTokenString, forKey: CacheConstants.deviceToken)
            
        }
        
        // Called when APNs failed to register the device for push notifications
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            // Print the error to console (you should alert the user that registration failed)
            print("APNs registration failed: \(error)")
        }
        // Push notification received
        func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
            // Print notification payload data
            print("Push notification received: \(data)")
        }
        /*
        else if(url.scheme!.isEqual("fb1831890057054527")) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        }
 */
        return false
    }
    
}

