//
//  SuggestedPlaylistTracksViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 29/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SuggestedPlaylistTracksViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, PoptableViewDelegate {
    
    
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    open var eventId : Int?
    open var eventInfoObj : UNSuggestedPlaylist?
    open var showPlaylist : Bool? = false
    open var isContentOffsetRequired : Bool? = false
    var tracksResponse : UNArtistPlaylistInfo?
    var eventPlayListArray : [UNEventPlaylistInfo] = [UNEventPlaylistInfo]()
    var serviceObj = CallServiceViewController()
    open var suggestedPlalistTrackId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tracksTableView.register(UINib(nibName: "SuggestedPlayTracksCell", bundle: nil), forCellReuseIdentifier: "SuggestedPlayTracksCell")
        tracksTableView.estimatedRowHeight = tracksTableView.rowHeight
        tracksTableView.rowHeight = UITableViewAutomaticDimension
        tracksTableView.reloadData()
        
        if (self.eventInfoObj?.artistPlaylistTracks.count == 0){
            self.noresultLabel.isHidden = false
        } else{
            self.noresultLabel.isHidden = true
            tracksTableView.reloadData()
        }
    
        serviceObj.getListOfEventPlaylist(eventId!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCustomNavBar(self, isMenuRequired: false, title: (eventInfoObj?.name)!, backhandler: {
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
        return 85
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SuggestedPlayTracksCell = tableView.dequeueReusableCell(withIdentifier: "SuggestedPlayTracksCell") as! SuggestedPlayTracksCell
        
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
                cell.spotifyBtn.isHidden = true
            } else {
                cell.spotifyBtn.tag = indexPath.row
                cell.spotifyBtn.addTarget(self, action: #selector(spotifyButtonClick(_:)), for: .touchUpInside)
                cell.spotifyBtn.isHidden = false
                cell.spotifyBtnWidth.constant = 25
            }
        } else {
            cell.spotifyBtn.isHidden = true
            cell.spotifyBtnWidth.constant = 0
        }
        
        cell.addButton.tag = indexPath.row
        
        if (showPlaylist)! {
            cell.addButton.layer.cornerRadius = 10
            cell.addButton.layer.masksToBounds = true
            cell.addButton.tag = indexPath.row
            
            cell.addButton.addTarget(self, action: #selector(addToPlaylistButtonEvent(_:)), for: .touchUpInside)
            cell.addButton.isHidden = false
        } else {
            cell.addButton.isHidden = true
        }
        return cell
        
    }
    
    @IBAction func addToPlaylistButtonEvent(_ sender: UIButton) {
        
        let tag = sender.tag
        
        let objDetails = self.eventInfoObj?.artistPlaylistTracks[tag]
        
        suggestedPlalistTrackId = objDetails?.id
        
        if serviceObj.myArrayFunc().count>0 {
            let popOverVC = PoptableViewController()
            popOverVC.delegate = self
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            //popOverVC.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 120)
            
            let buttonPosition = sender.convert(CGPoint(), to:tracksTableView)
            let indexPath = tracksTableView.indexPathForRow(at:buttonPosition)
            let rectOfCell = tracksTableView.rectForRow(at: indexPath!)
            let rectOfCellInSuperview = tracksTableView.convert(rectOfCell, to: self.view)
            // print("Y of Cell is: \(rectOfCellInSuperview.origin.y)")
            
            var tblY : CGFloat = 0.0
            if tracksTableView.contentSize.height <= (rectOfCell.origin.y + (rectOfCell.size.height * 2)) {
                tblY = rectOfCellInSuperview.origin.y + tracksTableView.frame.origin.y + (self.navigationController?.navigationBar.frame.height)! - 150;
                self.tracksTableView.setContentOffset(CGPoint.init(x: self.tracksTableView.contentOffset.x, y: self.tracksTableView.contentOffset.y + 120), animated: true)
                isContentOffsetRequired = true
            } else {
                isContentOffsetRequired = false
                tblY = rectOfCellInSuperview.origin.y + tracksTableView.frame.origin.y + (self.navigationController?.navigationBar.frame.height)! - 25;
            }
            
            
            
            let tblheight : CGFloat = CGFloat(3*40)
            
            popOverVC.setTableviewframe(xval: self.view.frame.width/2, yval: tblY,array: serviceObj.myArrayFunc(),height:tblheight)
            self.view.addSubview(popOverVC.view)
            
            
            popOverVC.didMove(toParentViewController: self)
        }
        
        
    }
    func selectedTableId(_ selectedrow: Int?) {
        self.tracksTableView.setContentOffset(CGPoint.init(x: self.tracksTableView.contentOffset.x, y: self.tracksTableView.contentOffset.y), animated: true)
        let array = serviceObj.myArrayFunc()
        let item = array[selectedrow!] as! UNEventPlaylistInfo
        
        addToPlaylist(item.eventPlaylistId!, suggestedPlaylistId: suggestedPlalistTrackId!)
    }
    
    func addToPlaylist(_ eventPlaylistId : Int,  suggestedPlaylistId : Int) {
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiAddPlaylistInSuggestedPlaylist(eventId!, playlistId: eventPlaylistId, suggestedPlaylistId: suggestedPlaylistId) {
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
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "The song was added successfully!", actions: nil)
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
 
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func likeButtonClick(_ sender: UIButton){
        let objDetails = self.eventInfoObj?.artistPlaylistTracks[sender.tag]
        let indexofvote = objDetails?.votes.index{$0.votingAccountId == Int(UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accountID) as! Int)}
        
        if indexofvote == nil {
            GLOBAL().showLoadingIndicatorWithMessage("")
           
            UNTZReqeustManager.sharedInstance.apiVoteSuggestedPlaylist((eventInfoObj?.eventId)!, suggestedPlaylistTrackId: (objDetails?.id)!, suggestedPlaylistId: (objDetails?.suggestedPlaylistId)!) {
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
            UNTZReqeustManager.sharedInstance.apiUnVoteSuggestedPlaylist((eventInfoObj?.eventId)!, suggestedPlaylistTrackId: (objDetails?.id)!, suggestedPlaylistId: (objDetails?.suggestedPlaylistId)!)  {
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
    
    func closeView() {
        if isContentOffsetRequired! {
            self.tracksTableView.setContentOffset(CGPoint.init(x: self.tracksTableView.contentOffset.x, y: self.tracksTableView.contentOffset.y - 120), animated: true)
        }
        
    }
    
}
