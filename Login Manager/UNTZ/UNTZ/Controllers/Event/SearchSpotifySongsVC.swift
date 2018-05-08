//
//  SearchSpotifySongsVC.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 20/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SearchSpotifySongsVC: UIViewController  , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var searchTracksTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spotifyLoginButton: UIButton!
    
    var requestedEventTrackResponse : UNSpotifyTracksInfo?
    let cellReuseIdendifier = "SearchSpotifyTracksCell"
    
    open var eventId : Int?
    open var searchText : String?
    var hasUserEnabledSpotifyAuth: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpotifyLoginManager.shared.delegate = self as SpotifyLoginManagerDelegate
/*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
 */
        searchBar.delegate = self
       
     searchTracksTableView.register(UINib(nibName: "SerachSpotifyTracksCell", bundle: nil), forCellReuseIdentifier: cellReuseIdendifier)
        
        //self.navigationController?.navigationBar.isHidden = true
        if hasUserEnabledSpotifyAuth == true {
            //spotifyLoginButton.isHidden = true
            searchBar.becomeFirstResponder()
        } else {
            //spotifyLoginButton.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        addCustomNavBar(self, isMenuRequired: false, title: "Search Songs", backhandler: {
            self.navigationController?.popViewController(animated: true)
        }) 

    }    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let searchText = searchText {
            if (searchText.count > 0) {
                searchBar.text = searchText
                searchBar.endEditing(true); self.searchRequestedTracks(searchBar.text!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logintoSpotify(_ sender: Any) {
        SpotifyLoginManager.shared.login()
    }

    //MARK :- Search Spotify Tracks
    
    func searchRequestedTracks(_ searchText : String) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiSearchRequestedTracks(searchText) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    self.requestedEventTrackResponse = UNSpotifyTracksInfo.init(jsonDict:dictionary)
                    
                    if self.requestedEventTrackResponse?.spotifyTrackList.count==0{
                        self.noresultLabel.isHidden = false
                    }else{
                        self.noresultLabel.isHidden = true
                    }
                    
                    self.searchTracksTableView.reloadData()
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requestedEventTrackResponse == nil {
            return 0
        } else
        {
            return (requestedEventTrackResponse?.spotifyTrackList.count)!;
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! SearchSpotifyTracksCell
        
        cell.shadowview.layer.shadowColor = UIColor.black.cgColor
        cell.shadowview.layer.shadowOffset = CGSize.zero
        cell.shadowview.layer.shadowOpacity = 0.2
        cell.shadowview.layer.shadowRadius = 5
        cell.shadowview.backgroundColor = UIColor.white
        
        let eventObj =  requestedEventTrackResponse?.spotifyTrackList[indexPath.row] as UNSpotifyTrackItemsInfo!
        
        cell.nameLabel.text = eventObj?.albumsInfo?.albumTrackName
        
        var characterArray : [String]=[]
        eventObj?.spotifyTrackArtistsInfoList.flatMap
            {$0}?
            .forEach { (eventTrackArtistsInfo:EventTrackArtistsInfo) in
                characterArray.append(eventTrackArtistsInfo.eventTrackName!)
        }
        
        cell.artistLabel.text = characterArray.joined(separator: " - ")
        
        if eventObj?.albumsInfo?.albumImage != nil{
            cell.requestImageView.sd_setImage(with: URL.init(string: (eventObj?.albumsInfo?.albumImage)!), completed: { (image, error, cacheType, imageURL) in
            })
        }
        //cell.selectionStyle = .none
        
        cell.requestButton.tag = indexPath.row;
        cell.requestButton.addTarget(self, action: #selector(requestSongButtonEvent(_:)), for: .touchUpInside)
        
        cell.playInSpotifyButton.tag = indexPath.row;
        cell.playInSpotifyButton.addTarget(self, action: #selector(playInSpotifyButtonEvent(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func playInSpotifyButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let spotifyTrackItemsInfo =  requestedEventTrackResponse?.spotifyTrackList[eventIndex!] as UNSpotifyTrackItemsInfo!
        
        let finalURL = "https://open.spotify.com/embed?uri=" + (spotifyTrackItemsInfo?.spotifyTrackUri!)!
        
        openURL(scheme: finalURL)
    }
    
    func openURL(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    @IBAction func requestSongButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let spotifyTrackItemsInfo =  requestedEventTrackResponse?.spotifyTrackList[eventIndex!] as UNSpotifyTrackItemsInfo!
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil
        {
            requestSpotifyTrack(jsonDict: (spotifyTrackItemsInfo?.jsonReponseDict)!)
        }
        else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not authorised user to perform this action!", actions: nil)
        }
        
    }
    
    func requestSpotifyTrack(jsonDict : [String : AnyObject]) {
        GLOBAL().showLoadingIndicatorWithMessage("")

        UNTZReqeustManager.sharedInstance.apiRequestSpotifySong(eventId!, bodyParameters: jsonDict) {
        (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            }
            else
            {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>
                {
                    let dataValue = dictionary["data"] as! Dictionary<String, AnyObject>
                    
                    let successValue = dataValue["success"] as! Bool
                    
                    //let updatedRsvpStatus = dataValue["updatedRsvpStatus"] as! Bool
                    
                    if successValue == true {

                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
    
    /*
     func requestSongTrack(jsonDict : Dictionary<String,AnyObject>) {
     GLOBAL().showLoadingIndicatorWithMessage("")
     
     UNTZReqeustManager.sharedInstance.apiAcceptOrRejectRequest(eventId!, eventRequestedTrackId: eventRequestedTrackId, isAccept: isAccept) {
     (feedResponse) -> Void in
     GLOBAL().hideLoadingIndicator()
     
     if let downloadError = feedResponse.error{
     print(downloadError)
     GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
     } else {
     GLOBAL().hideLoadingIndicator()
     
     if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
     let dataValue = dictionary["data"] as! Bool!
     
     if dataValue == true {
     self.refreshList()
     } else {
     GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
     }
     }
     }
     }
     }
     */
    func refreshList()  {
        //requestedEventTrackResponse = nil
        //self.getListOfRequestedTracks(eventId!)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            if text.count > 0 {
                searchBar.resignFirstResponder()
                self.searchRequestedTracks(searchBar.text!)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    

}

extension SearchSpotifySongsVC: SpotifyLoginManagerDelegate {
    func loginManagerDidLoginWithSuccess(accessToken: String) {
        dismiss(animated: true, completion: nil)
        spotifyLoginButton.isHidden = true
    }
}
