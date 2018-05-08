//
//  EventPlayListsViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 13/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class EventPlayListsViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    open var eventId : Int?
    open var showPlaylist : Bool? = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var emptyImgview: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noresultimgView: UIImageView!
    @IBOutlet weak var noresultLbl: UILabel!
    var eventPlayListArray = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let main_string = "Use Suggested Playlists to add songs to the Event Playlists."
        let string_to_color = "Suggested Playlists"
        
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attributedString = NSMutableAttributedString(string:main_string)
   
        let attributes: [String:AnyObject] =
            [NSForegroundColorAttributeName : UIColor.init(red: 190/255, green: 20/255, blue: 17/255, alpha: 1.0),
             NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue as AnyObject]
        
        attributedString.addAttributes(attributes, range: range)
        headerLabel.attributedText = attributedString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        headerLabel.isUserInteractionEnabled = true
        headerLabel.addGestureRecognizer(tapGesture)
        
        //eventPlayListCell
        tblView.register(UINib(nibName: "EventPlayListCell", bundle: nil), forCellReuseIdentifier: "eventPlayListCell")
        tblView.estimatedRowHeight = tblView.rowHeight
        tblView.rowHeight = UITableViewAutomaticDimension
        
        
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.borderWidth = 1.0
        headerView.layer.cornerRadius = 3.5

        if showPlaylist! {
            headerView.isHidden = false
            headerViewHeightConstraint.constant = 40
        } else {
            headerView.isHidden = true
            headerViewHeightConstraint.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        addCustomNavBar(self, isMenuRequired: false, title: "Event Playlists", backhandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if eventPlayListArray.count > 0
        {
            eventPlayListArray.removeAllObjects()
        }
        self.getListOfEventPlaylist()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDSuggestedPlayListsVC") as! SuggestedPlaylistViewController
        
        detailObj.eventId = eventId
        detailObj.showPlaylist = showPlaylist
        pushStoryObj(obj: detailObj, on: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventPlayListArray.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80 //Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventPlayListCell = tableView.dequeueReusableCell(withIdentifier: "eventPlayListCell") as! EventPlayListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let infoObj = eventPlayListArray.object(at: (indexPath as NSIndexPath).row) as? UNEventPlaylistInfo
         cell.eventNameLable.text = infoObj?.playlistName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoObj = eventPlayListArray.object(at: (indexPath as NSIndexPath).row) as? UNEventPlaylistInfo
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDPlayListVC") as! PlayListViewController
        detailObj.eventId = eventId
        detailObj.eventInfoObj = infoObj
        detailObj.showPlaylist = showPlaylist
        pushStoryObj(obj: detailObj, on: self)
    }
    @IBAction func clickCreateEvent(_ sender: Any) {
        if titleTextfield.text?.count == 0 {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Please enter playlist name!", actions: nil)

            return
        } else {
            titleTextfield.endEditing(true)
            
            createPlaylist(playListName: (titleTextfield.text)!)
        }
    }
    
    func createPlaylist(playListName : String) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiCreateEventPlaylist(eventId!, playlistName: playListName) {
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
                        self.titleTextfield.text = nil
                        self.refreshEventPlaylist()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                    
                }
            }
        }
    }

    func refreshEventPlaylist() {
        if eventPlayListArray.count > 0 {
            eventPlayListArray.removeAllObjects()
        }
        getListOfEventPlaylist()
    }
    
    func getListOfEventPlaylist() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiGetEventPlaylist(eventId!, excludeTracks: true) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    
                    let data = dictionary["data"] as! Dictionary<String, AnyObject>
                    
                    if let playlistdata = data["eventPlaylists"] as? Array<Dictionary<String, AnyObject>> {
                        for playlistDict in playlistdata{
                            let playlistInfo = UNEventPlaylistInfo.init(jsonDict: playlistDict)
                            self.eventPlayListArray.add(playlistInfo)
                        }
                        if (self.eventPlayListArray.count == 0){
                        self.tblView.isHidden = true
                        self.noresultimgView.isHidden = false
                        self.noresultLbl.isHidden = false
                            self.headerLabel.isHidden = true
                        }else{
                            self.tblView.isHidden = false
                            self.noresultimgView.isHidden = true
                            self.noresultLbl.isHidden = true
                            self.headerLabel.isHidden = false
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
}
