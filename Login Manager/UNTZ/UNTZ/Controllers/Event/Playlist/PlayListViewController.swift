//
//  PlayListViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 23/01/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PlayListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    open var eventId : Int?
    open var eventInfoObj : UNEventPlaylistInfo?
    open var showPlaylist : Bool? = false
    var tracksResponse : UNArtistPlaylistInfo?
    var eventPlayListArray : [UNEventPlaylistInfo] = [UNEventPlaylistInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tracksTableView.register(UINib(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "playListCell")
        tracksTableView.estimatedRowHeight = tracksTableView.rowHeight
        tracksTableView.rowHeight = UITableViewAutomaticDimension
        tracksTableView.reloadData()
        
        if (self.eventInfoObj?.artistPlaylistTracks.count == 0){
            self.noresultLabel.isHidden = false
        } else{
            self.noresultLabel.isHidden = true
            tracksTableView.reloadData()
        }
        
        if showPlaylist! {
            let main_string = "The playlist has no tracks added to it yet. You can add tracks from Suggested Playlists."
            let string_to_color = "Suggested Playlists"
            
            let range = (main_string as NSString).range(of: string_to_color)
            
            let attributedString = NSMutableAttributedString(string:main_string)
            
            let attributes: [String:AnyObject] =
                [NSForegroundColorAttributeName : UIColor.init(red: 190/255, green: 20/255, blue: 17/255, alpha: 1.0),
                 NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue as AnyObject]
            
            attributedString.addAttributes(attributes, range: range)
            noresultLabel.attributedText = attributedString
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            noresultLabel.isUserInteractionEnabled = true
            noresultLabel.addGestureRecognizer(tapGesture)
            
        } else {
            noresultLabel.isUserInteractionEnabled = false
            noresultLabel.text = "The playlist has no tracks added to it yet."
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCustomNavBar(self, isMenuRequired: false, title: (eventInfoObj?.playlistName)!, backhandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventInfoObj?.artistPlaylistTracks == nil  {
            return 0
        } else
        {
            return (self.eventInfoObj?.artistPlaylistTracks.count)!;
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PlayListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "playListCell") as! PlayListTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let objDetails = self.eventInfoObj?.artistPlaylistTracks[indexPath.row]
        
        cell.artistNameLbl.text = objDetails?.artists[0].spotifyArtistName
        
        cell.trackTitleLbl.text = objDetails?.name
        
        cell.likeCntLbl.text = "\(objDetails?.votes.count ?? 0)"
        
        let indexofvote = objDetails?.votes.index{$0.votingAccountId == Int(UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accountID) as! Int )}
        
        if indexofvote == nil {
            cell.LikeBtn.setImage(UIImage(named: "likesG")!, for: .normal)
            cell.likeCntLbl.textColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        }else{
            cell.LikeBtn.setImage(UIImage(named: "likesR")!, for: .normal)
            cell.likeCntLbl.textColor = UIColor(red: 131.0/255.0, green: 23.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        }
        
        cell.trackImageV.setShowActivityIndicator(true)
        cell.trackImageV.setIndicatorStyle(.gray)
        
        if ((objDetails?.imageUrl) != nil) {
            cell.trackImageV.sd_setImage(with: URL(string: (objDetails?.imageUrl)!), placeholderImage: UIImage(named: "ic_no_track_playlist"))
        }else{
            cell.trackImageV.image = UIImage(named: "ic_no_track_playlist")
        }
        cell.LikeBtn.tag = indexPath.row
        cell.LikeBtn.addTarget(self, action: #selector(likeButtonClick(_:)), for: .touchUpInside)
        
        if let trackURI = objDetails?.spotifyTrackUri {
            if trackURI.length == 0 {
                cell.spotifyBtnWidth.constant = 0
                cell.spotifyBtnSideSpace.constant = 0
                cell.spotifyBtn.isHidden = true
            } else {
                cell.spotifyBtn.tag = indexPath.row
                cell.spotifyBtn.addTarget(self, action: #selector(spotifyButtonClick(_:)), for: .touchUpInside)
                cell.spotifyBtn.isHidden = false
                cell.spotifyBtnWidth.constant = 25
                cell.spotifyBtnSideSpace.constant = 13
            }
        } else {
            cell.spotifyBtn.isHidden = true
            cell.spotifyBtnWidth.constant = 0
            cell.spotifyBtnSideSpace.constant = 0
        }
        
        cell.spotifyBtn.tag = indexPath.row
        cell.spotifyBtn.addTarget(self, action: #selector(spotifyButtonClick(_:)), for: .touchUpInside)
         cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonClick(_:)), for: .touchUpInside)
       
        return cell
        
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    func likeButtonClick(_ sender: UIButton){
        let objDetails = self.eventInfoObj?.artistPlaylistTracks[sender.tag]
        let indexofvote = objDetails?.votes.index{$0.votingAccountId == Int(UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accountID) as! Int)}
        
        if indexofvote == nil {
            GLOBAL().showLoadingIndicatorWithMessage("")
            UNTZReqeustManager.sharedInstance.apiVoteEventPlaylist((eventInfoObj?.eventId)!, eventPlaylistTrackId: (objDetails?.id)!, eventPlaylistId: (objDetails?.eventPlaylistId)!) {
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
                            let voteDic = NSMutableDictionary();                            voteDic.setValue((UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accountID) as! Int ), forKey : "votingAccountId")
                            let votesInfo = UNUserVotes.init(jsonDict: voteDic as! Dictionary<String, AnyObject>)
                            objDetails?.votes.append(votesInfo)
                            let indexPath = IndexPath(item: sender.tag, section: 0)
                            self.tracksTableView.reloadRows(at: [indexPath], with: .top)
                        } else {
                            GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                        }
                    }
                }
            }
            
        }else{
            GLOBAL().showLoadingIndicatorWithMessage("")
            UNTZReqeustManager.sharedInstance.apiUnVoteEventPlaylist((eventInfoObj?.eventId)!, eventPlaylistTrackId: (objDetails?.id)!, eventPlaylistId: (objDetails?.eventPlaylistId)!) {
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
                             objDetails?.votes.remove(at: indexofvote!)
                            let indexPath = IndexPath(item: sender.tag, section: 0)
                            self.tracksTableView.reloadRows(at: [indexPath], with: .top)
                        } else {
                            GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                        }
                    }
                }
            }
           
        }
       
    }
    func spotifyButtonClick(_ sender: UIButton){
        let eventInfo = self.eventInfoObj?.artistPlaylistTracks[sender.tag]
        let finalURL = "https://open.spotify.com/embed?uri=" + (eventInfo?.spotifyTrackUri)!
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
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        let objDetails = self.eventInfoObj?.artistPlaylistTracks[sender.tag]
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiDeleteEventPlaylistTrack((eventInfoObj?.eventId)!, playListId: (eventInfoObj?.eventPlaylistId)!,playListTrackId:(objDetails?.id)!) {
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
                        self.eventInfoObj?.artistPlaylistTracks.remove(at: sender.tag)
                        self.tracksTableView.reloadData()
                        
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }

        

    }
  
    @IBAction func deletePlaylistClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete playlist?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                GLOBAL().showLoadingIndicatorWithMessage("")
                UNTZReqeustManager.sharedInstance.apiDeleteEventPlaylist((self.eventInfoObj?.eventId)!, playListId: (self.eventInfoObj?.eventPlaylistId)!) {
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
                                self.navigationController?.popViewController(animated: false)
                            } else {
                                GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                            }
                        }
                    }
                }

                
            }}))
        self.present(alert, animated: true, completion: nil)


        
        
    }
    
    @IBAction func renamePlaylistClicked(_ sender: Any) {
        var inputTextField: UITextField?
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Rename", message: "", preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            if inputTextField?.text?.count == 0 {
                GLOBAL().showAlert(APPLICATION.applicationName, message: "Please enter playlist name!", actions: nil)
                return
            } else {
                GLOBAL().showLoadingIndicatorWithMessage("")
                UNTZReqeustManager.sharedInstance.apiRenameEventPlaylist((self.eventInfoObj?.eventId)!, playListId: (self.eventInfoObj?.eventPlaylistId)!, playlistName:(inputTextField?.text)!) {
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
                              self.navigationController?.popViewController(animated: false)
                            } else {
                                GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                            }
                        }
                    }
                }
            }
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        actionSheetController.addTextField { textField -> Void in
            // you can use this text field
            inputTextField = textField
            inputTextField?.text = self.eventInfoObj?.playlistName
        }
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDSuggestedPlayListsVC") as! SuggestedPlaylistViewController
        
        detailObj.eventId = eventId
        detailObj.showPlaylist = showPlaylist
        pushStoryObj(obj: detailObj, on: self)
    }
}
