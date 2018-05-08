//
//  LoginManager.swift
//  Greencopper Spotify Test
//
//  Created by Wojciech on 2017-09-18.
//  Copyright © 2017 Wojtek. All rights reserved.
//

import Foundation
import SafariServices

protocol SpotifyLoginManagerDelegate: class {
    func loginManagerDidLoginWithSuccess(accessToken : String)
}

class SpotifyLoginManager {
    
    static var shared = SpotifyLoginManager()
    private init() {
        let redirectURL = "UNTZ://"
        let clientID = "09e62bfcff1e48edb8a06af1210a6c02"
        auth.sessionUserDefaultsKey = "kCurrentSession"
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        auth.tokenSwapURL = URL.init(string: "swapURL")

        auth.tokenRefreshURL = URL.init(string: "refreshURL")
        
    }

    weak var delegate: SpotifyLoginManagerDelegate?
    var auth = SPTAuth.defaultInstance()!
    private var session: SPTSession? {
        if let sessionObject = UserDefaults.standard.object(forKey: auth.sessionUserDefaultsKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: sessionObject) as? SPTSession
        }
        return nil
    }
    var isLogged: Bool {
        if let session = session {
            print(session.accessToken!)
            return session.isValid()
        }
        return false
    }
    
    func login() {
        let safariVC = SFSafariViewController(url: auth.spotifyWebAuthenticationURL())
        UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }
    
    func handled(url: URL) -> Bool {
        guard auth.canHandle(auth.redirectURL) else {return false}
        auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
            if error != nil {
                print("error!")
            }
            print(session?.accessToken as String!)
            print(session?.encryptedRefreshToken as String!)
           
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Success \(session?.accessToken)!", actions: nil)
 self.delegate?.loginManagerDidLoginWithSuccess(accessToken: (session?.accessToken)!)
        })
        return true
    }
}
