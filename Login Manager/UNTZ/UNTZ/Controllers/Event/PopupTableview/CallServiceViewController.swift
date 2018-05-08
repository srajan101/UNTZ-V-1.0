//
//  CallServiceViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 10/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class CallServiceViewController: UIViewController {
    var eventPlayListArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func getListOfEventPlaylist(_ eventId : Int) {
        //GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiGetEventPlaylist(eventId, excludeTracks: true) {
            (feedResponse) -> Void in
            //GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                //GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    
                    let data = dictionary["data"] as! Dictionary<String, AnyObject>
                    
                    if let playlistdata = data["eventPlaylists"] as? Array<Dictionary<String, AnyObject>> {
                        for playlistDict in playlistdata{
                            let playlistInfo = UNEventPlaylistInfo.init(jsonDict: playlistDict)
                            self.eventPlayListArray.add(playlistInfo)
                        }
                    }
                }
            }
        }
    }
    
    func myArrayFunc() -> NSMutableArray {
        return self.eventPlayListArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
