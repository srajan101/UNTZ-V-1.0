//
//  UNTrackRequestsVC.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 08/08/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var requestImageView: UIImageView!
    
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var timeLabel: UNLabel!
    
    @IBOutlet weak var NameLabel: UNLabel!
    @IBOutlet weak var RequestLabel: UNLabel!
    @IBOutlet weak var artistLabel: UNLabel!
    
    @IBOutlet weak var acceptedUserNameLabel: UNLabel!
    //@IBOutlet weak var deleteBtn: UIButton!
    //@IBOutlet weak var acceptBtn: UIButton!
     @IBOutlet weak var parentview: UIView!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var addToPlaylistButton: UIButton!
    @IBOutlet weak var playInSpotifyButton: UIButton!
    
    @IBOutlet weak var acceptedByNameLabel: UNLabel!
    
    var hasUserEnabledSpotifyAuth: Bool?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
 }
    
class UNTrackRequestsVC: UIViewController , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,PoptableViewDelegate {
    func closeView() {
        
    }
    
    
    
    
    @IBOutlet weak var requestedTracksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var requestedEventTrackResponse : UnEventTrackResponse?
    let cellReuseIdendifier = "cell"
    open var eventId : Int?
    open var eventRequestedTrackId : Int?
    open var showPlaylist : Bool? = false
    var hasUserEnabledSpotifyAuth: Bool?
    var serviceObj = CallServiceViewController()
    @IBOutlet weak var noresultLabel: UNLabel!
    @IBOutlet weak var noresultsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        */
        // Do any additional setup after loading the view.
        serviceObj.getListOfEventPlaylist(eventId!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        addCustomNavBar(self, isMenuRequired: false, title: "Requests", backhandler: {
            self.navigationController?.popViewController(animated: true)
        }) 

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func movetoSpotify(_ sender: Any) {
        
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDSearchSpotifySongsVC") as! SearchSpotifySongsVC
        /*if !SpotifyLoginManager.shared.isLogged {
            detailObj.hasUserEnabledSpotifyAuth = false
        }else{
            detailObj.hasUserEnabledSpotifyAuth = true
        }
         */
        detailObj.hasUserEnabledSpotifyAuth = hasUserEnabledSpotifyAuth
        detailObj.eventId = eventId!
        pushStoryObj(obj: detailObj, on: self)
    }
    
    // MARK: -
    
    override func viewDidAppear(_ animated: Bool) {
        refreshList()
    }
    
    func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    //MARK :- Get List Of Events
    
    func getListOfRequestedTracks(_ eventId : Int) {
        if self.requestedEventTrackResponse == nil || self.requestedEventTrackResponse?.requestedTrackInfoList.count==0{
            GLOBAL().showLoadingIndicatorWithMessage("")
        }
    UNTZReqeustManager.sharedInstance.apiGetListOfRequestedTracks(eventId) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                        self.requestedEventTrackResponse = UnEventTrackResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                   
                    if self.requestedEventTrackResponse?.requestedTrackInfoList.count==0{
                            self.noresultLabel.isHidden = false
                        self.noresultsImageView.isHidden = false
                        }else{
                            self.noresultLabel.isHidden = true
                        self.noresultsImageView.isHidden = true
                        }
                        
                    self.requestedTracksTableView.reloadData()
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
            return (requestedEventTrackResponse?.requestedTrackInfoList.count)!;
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180 //Choose your custom row height
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! RequestCell
        cell.shadowview.layer.shadowColor = UIColor.black.cgColor
        cell.shadowview.layer.shadowOffset = CGSize.zero
        cell.shadowview.layer.shadowOpacity = 0.2
        cell.shadowview.layer.shadowRadius = 5
        cell.shadowview.backgroundColor = UIColor.white
        
       let eventObj =  requestedEventTrackResponse?.requestedTrackInfoList[indexPath.row] as RequestedTrackInfo!
        
        cell.timeLabel.text  = self.timediffernce(dateStr: (eventObj?.requestDateTime)!)
        

        //cell.profileView.startAnimationOfImage(animation: false)
        cell.profileView.sd_setImage(with: URL.init(string: (eventObj?.guestsInfo?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
            //cell.profileView.stopAnimationOfImage()
        })
        
        cell.profileView.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell.profileView.isUserInteractionEnabled = true
        cell.profileView.addGestureRecognizer(tapGesture)

        cell.NameLabel.text = eventObj?.guestsInfo?.fullName
        cell.RequestLabel.text = eventObj?.spotifyTrackName
        
        cell.NameLabel.tag = indexPath.row
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(tapGesture1)
        
        if let acceptedByName = eventObj?.acceptedByName {
            cell.acceptedUserNameLabel.isHidden = false
            cell.acceptedByNameLabel.isHidden = false
            cell.acceptedUserNameLabel.text = acceptedByName
            
            cell.acceptedUserNameLabel.tag = indexPath.row
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleAcceptedUserNameTap(sender:)))
            cell.acceptedUserNameLabel.isUserInteractionEnabled = true
            cell.acceptedUserNameLabel.addGestureRecognizer(tapGesture1)
            
        }
        else {
            cell.acceptedUserNameLabel.isHidden = true
            cell.acceptedByNameLabel.isHidden = true
        }
        
        
        var characterArray : [String]=[]
        eventObj?.eventTrackArtistsInfoList.flatMap 
            {$0}?
                .forEach { (eventTrackArtistsInfo:EventTrackArtistsInfo) in
                    characterArray.append(eventTrackArtistsInfo.eventTrackName!)
        }
    
        cell.artistLabel.text = characterArray.joined(separator: " - ")
        
        if eventObj?.spotifyAlbumImageUri != nil{
            cell.requestImageView.sd_setImage(with: URL.init(string: (eventObj?.spotifyAlbumImageUri)!), completed: { (image, error, cacheType, imageURL) in
                //cell.linkImageview.stopAnimationOfImage()
            })
        }
        cell.selectionStyle = .none
        
       cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height / 2
        cell.profileView.clipsToBounds = true
        
        //cell.acceptBtn.isHidden = true
        if (eventObj?.guestsInfo?.facebookUserId == eventObj?.currentUserInfo?.facebookUserId) {
            //cell.deleteBtn.isHidden = false
            //cell.deleteBtn.tag = indexPath.row
            //cell.deleteBtn.addTarget(self, action: #selector(deleteRequestButtonEvent(_:)), for: .touchUpInside)

            if (eventObj?.isUserAdminOrArtist!)! {
                //cell.acceptBtn.isHidden = false
                //cell.acceptBtn.tag = indexPath.row;
                //cell.acceptBtn.addTarget(self, action: #selector(acceptButtonEvent(_:)), for: .touchUpInside)
            } else {
                //cell.acceptBtn.isHidden = true
            }

        }
        else {
            //cell.deleteBtn.isHidden = true
            /*
            if (eventObj?.isUserAdminOrArtist!)! {
                if (eventObj?.isSongAccepted!)! {
                    cell.acceptBtn.setImage(UIImage(named: "undo_cancel"), for: .normal)
                } else {
                    cell.acceptBtn.setImage(UIImage(named: "acceptBtn"), for: .normal)
                    
                }
                cell.acceptBtn.tag = indexPath.row;
                cell.acceptBtn.addTarget(self, action: #selector(acceptButtonEvent(_:)), for: .touchUpInside)
            }*/
        }
        
        if (showPlaylist)! {
            cell.addToPlaylistButton.layer.cornerRadius = 10
            cell.addToPlaylistButton.layer.masksToBounds = true
            cell.addToPlaylistButton.tag = indexPath.row
            
            cell.addToPlaylistButton.addTarget(self, action: #selector(addToPlaylistButtonEvent(_:)), for: .touchUpInside)
            cell.addToPlaylistButton.isHidden = false
        } else {
            cell.addToPlaylistButton.isHidden = true
        }
        

        cell.playInSpotifyButton.addTarget(self, action: #selector(playInSpotifyButtonEvent(_:)), for: .touchUpInside)

        cell.parentview.backgroundColor = UIColor.white
        return cell
    }
    
    func refreshList()  {        
        searchBar.text = nil
        requestedEventTrackResponse = nil
        self.getListOfRequestedTracks(eventId!)
        
    }
    
    @IBAction func deleteRequestButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let requestedTrackInfo = requestedEventTrackResponse?.requestedTrackInfoList[eventIndex!] as RequestedTrackInfo!
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiDeleteRequest(eventId!, eventRequestedTrackId: (requestedTrackInfo?.trackID)!) {
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

    @IBAction func acceptButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let requestedTrackInfo = requestedEventTrackResponse?.requestedTrackInfoList[eventIndex!] as RequestedTrackInfo!
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if requestedTrackInfo?.isUserAdminOrArtist == true {
                if (requestedTrackInfo?.isSongAccepted)! {
                    acceptOrRejectSong(false,(requestedTrackInfo?.trackID)!)
                } else {
                    acceptOrRejectSong(true,(requestedTrackInfo?.trackID)!)
                }
            } else {
                GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not authorised user to perform this action!", actions: nil)
            }
        }
        
    }
    
    func acceptOrRejectSong(_ isAccept : Bool, _ eventRequestedTrackId : Int) {
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
    
    func timediffernce(dateStr : String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        
        let date = dateFormatter.date(from: dateStr) //according to date format your date string
        let now = Date()
        let timeOffset = now.offset(from:date! ) //
        return ("\(timeOffset) ago")
        
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
                let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDSearchSpotifySongsVC") as! SearchSpotifySongsVC
                detailObj.hasUserEnabledSpotifyAuth = hasUserEnabledSpotifyAuth
                detailObj.eventId = eventId!
                detailObj.searchText = text
                pushStoryObj(obj: detailObj, on: self)
            }
        }
    }
    
    func handleAcceptedUserNameTap(sender: UITapGestureRecognizer) {
        let view = sender.view
        
        if let tag = view?.tag {
            let eventObj =  requestedEventTrackResponse?.requestedTrackInfoList[tag] as RequestedTrackInfo!
            
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
            
            //let userID = String.init(format: "%ld", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accountID) as! Int)
            let defaults = UserDefaults.standard
            let accountId = defaults.integer(forKey: UNUserInfoKeys.accountID)
            
            if(eventObj?.guestsInfo?.userId ==  accountId) {
                detailObj.isFanProfile = true
                detailObj.userID = String.init(format: "%ld", accountId)
            } else {
                detailObj.isFanProfile = true
                detailObj.userID = String.init(format: "%ld", (eventObj?.acceptedByUserId)!)
            }
            
            pushStoryObj(obj: detailObj, on: self)
        }
        
    }
    
    
    // 3. this method is called when a tap is recognized
    func handleTap(sender: UITapGestureRecognizer) {
        let view = sender.view
        
        if let tag = view?.tag {
            let eventObj =  requestedEventTrackResponse?.requestedTrackInfoList[tag] as RequestedTrackInfo!

            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
            
            let userID = String.init(format: "%@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! CVarArg)
            if(eventObj?.guestsInfo?.aspNetUserId ==  userID) {
                detailObj.isFanProfile = true
                detailObj.userID = userID
            } else {
                detailObj.isFanProfile = true
                detailObj.userID = String.init(format: "%ld", (eventObj?.guestsInfo?.userId)!)
            }
            
            pushStoryObj(obj: detailObj, on: self)
        }
        
    }
    
    @IBAction func addToPlaylistButtonEvent(_ sender: UIButton) {
        
        let tag = sender.tag
        
        let eventObj =  requestedEventTrackResponse?.requestedTrackInfoList[tag] as RequestedTrackInfo!
            
        eventRequestedTrackId = eventObj?.trackID
        
        if serviceObj.myArrayFunc().count>0 {
            let popOverVC = PoptableViewController()
            popOverVC.delegate = self
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            
            let buttonPosition = sender.convert(CGPoint(), to:requestedTracksTableView)
            let indexPath = requestedTracksTableView.indexPathForRow(at:buttonPosition)
            let rectOfCell = requestedTracksTableView.rectForRow(at: indexPath!)
            let rectOfCellInSuperview = requestedTracksTableView.convert(rectOfCell, to: self.view)
           // print("Y of Cell is: \(rectOfCellInSuperview.origin.y)")

            let tblY = rectOfCellInSuperview.origin.y + requestedTracksTableView.frame.origin.y + (self.navigationController?.navigationBar.frame.height)! + 5;
       
            let tblheight : CGFloat = CGFloat(serviceObj.myArrayFunc().count*40)

            popOverVC.setTableviewframe(xval: self.view.frame.width/2, yval: tblY,array: serviceObj.myArrayFunc(),height:tblheight)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
       

    }
    func selectedTableId(_ selectedrow: Int?) {
        let array = serviceObj.myArrayFunc()
        let item = array[selectedrow!] as! UNEventPlaylistInfo
        
        addToPlaylist(item.eventPlaylistId!, eventRequestedTrackId: eventRequestedTrackId!)
    }
    
    func addToPlaylist(_ eventPlaylistId : Int,  eventRequestedTrackId : Int) {
        
        GLOBAL().showLoadingIndicatorWithMessage("")
    UNTZReqeustManager.sharedInstance.apiAddPlaylistToRequestedTrack(eventId!, eventPlaylistId: eventPlaylistId, reuestedTrackId: eventRequestedTrackId) {
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
    
    @IBAction func playInSpotifyButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let eventObj =  requestedEventTrackResponse?.requestedTrackInfoList[eventIndex!] as RequestedTrackInfo!

        let finalURL = "https://open.spotify.com/embed?uri=" + (eventObj?.spotifyTrackUri)!
        
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
}

