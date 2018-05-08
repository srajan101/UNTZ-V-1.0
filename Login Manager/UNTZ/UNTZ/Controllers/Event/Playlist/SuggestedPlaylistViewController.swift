//
//  SuggestedPlaylistViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 18/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SuggestedPlaylistViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    open var eventId : Int?
    open var showPlaylist : Bool? = false
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var emptyImgview: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var noresultimgView: UIImageView!
    @IBOutlet weak var noresultLbl: UILabel!
    
    var suggestedEventPlayListArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eventPlayListCell
        tblView.register(UINib(nibName: "SuggestedEventsCell", bundle: nil), forCellReuseIdentifier: "SuggestedEventPlayListCell")
        tblView.estimatedRowHeight = tblView.rowHeight
        tblView.rowHeight = UITableViewAutomaticDimension
        
        getListOfSuggestedEventPlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        addCustomNavBar(self, isMenuRequired: false, title: "Suggested Playlists", backhandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestedEventPlayListArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80 //Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SuggestedEventsCell = tableView.dequeueReusableCell(withIdentifier: "SuggestedEventPlayListCell") as! SuggestedEventsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let infoObj = suggestedEventPlayListArray.object(at: (indexPath as NSIndexPath).row) as? UNSuggestedPlaylist
        cell.eventNameLable.text = infoObj?.name
        
        cell.artistPictImageView.layer.cornerRadius = cell.artistPictImageView.frame.size.height / 2
        cell.artistPictImageView.layer.masksToBounds = true
        
        cell.artistPictImageView.setShowActivityIndicator(true)
        cell.artistPictImageView.setIndicatorStyle(.gray)
        
        cell.artistPictImageView.sd_setImage(with: URL(string: (infoObj?.artistAccount?.pictureUrl)!), placeholderImage: UIImage.init(named: "default_user_pict"))
        
        //cell.deleteButton.tag = indexPath.row
        //cell.deleteButton.addTarget(self, action: #selector(deleteButtonEvent(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoObj = suggestedEventPlayListArray.object(at: (indexPath as NSIndexPath).row) as? UNSuggestedPlaylist
        
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDSuggestedTracksVC") as! SuggestedPlaylistTracksViewController
        detailObj.eventId = eventId
        detailObj.eventInfoObj = infoObj
        detailObj.showPlaylist = showPlaylist
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func deleteButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let infoObj = suggestedEventPlayListArray.object(at: eventIndex!) as? UNSuggestedPlaylist
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete suggested playlist?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            switch action.style{
                case .default:
                    print("default")
                
                case .cancel:
                    print("cancel")
                
                case .destructive:
                print("destructive")
                    self.deletePlaylist(suggestedPlaylistId: (infoObj?.artistPlaylistId)!)
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func deletePlaylist(suggestedPlaylistId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
       
       UNTZReqeustManager.sharedInstance.apiDeleteSuggestedPlaylist(eventId!, suggestedPlaylistId: suggestedPlaylistId) {
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
                        self.refreshEventPlaylist()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                    
                }
            }
        }
    }
    
    func refreshEventPlaylist() {
        if suggestedEventPlayListArray.count > 0 {
            suggestedEventPlayListArray.removeAllObjects()
        }
        getListOfSuggestedEventPlaylist()
    }
    
    func getListOfSuggestedEventPlaylist() {
        GLOBAL().showLoadingIndicatorWithMessage("")
       UNTZReqeustManager.sharedInstance.apiGetSuggestedEventPlaylist(eventId!) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    
                    let data = dictionary["data"] as! Dictionary<String, AnyObject>
                    
                    if let playlistdata = data["suggestedPlaylists"] as? Array<Dictionary<String, AnyObject>> {
                        for playlistDict in playlistdata{
                            let playlistInfo = UNSuggestedPlaylist.init(jsonDict: playlistDict)
                            self.suggestedEventPlayListArray.add(playlistInfo)
                        }
                        if (self.suggestedEventPlayListArray.count == 0){
                            self.tblView.isHidden = true
                            self.noresultimgView.isHidden = false
                            self.noresultLbl.isHidden = false
                            self.headerLabel.isHidden = true
                        }else{
                            self.headerLabel.isHidden = false
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
