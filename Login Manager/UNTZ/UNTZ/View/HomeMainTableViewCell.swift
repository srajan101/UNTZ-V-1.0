//
//  HomeMainTableViewCell.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 01/05/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit
import SDWebImage

class HomeMainTableViewCell: UITableViewCell {
    @IBOutlet weak var RSVPStatusLabel: UNLabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var hostedByLabel: UNLabel!
    @IBOutlet weak var placeLable: UNLabel!
    @IBOutlet weak var peopleCountLabel: UNLabel!
    @IBOutlet weak var timeLabel: UNLabel!
    @IBOutlet weak var dateDayLabel: UNLabel!
    @IBOutlet weak var eventNameLabel: UNLabel!
    @IBOutlet weak var eventTypeLabel: UNLabel!
    @IBOutlet weak var dateMonthLabel: UNLabel!
    
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interestedBtn: UNButton!
    
    @IBOutlet weak var RSVPTopSpaceConstrint: NSLayoutConstraint!
    @IBOutlet weak var RSVPHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonHeightConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let buttonImage = UIImage(named: "star")
        interestedBtn.setImage(buttonImage, for: .normal)
        interestedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0)
        interestedBtn.layer.cornerRadius = 3.5;
        interestedBtn.layer.borderWidth = 1;
        interestedBtn.layer.borderColor = UIColor.red.cgColor
        
        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 5
        shadowview.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true

    }
    func updateUI(urlstr : String){
        SDWebImageManager.shared().downloadImage(with: NSURL(string: urlstr) as URL!, options: .continueInBackground, progress: {
            (receivedSize :Int, ExpectedSize :Int) in
            
        }, completed: {
            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
            if(error == nil) {
                //print(image?.size.width ?? 0)
                //print(image?.size.height ?? 0)
                //print(self.eventImageView?.frame.size.width ?? 0)
                //print(self.eventImageView?.frame.size.height ?? 0)
                
                var newImageHeight : CGFloat = 0.0
                var newImageWidth : CGFloat = 0.0
                if (DYNAMICFONTSIZE.IS_IPHONE_5) {
                    newImageHeight = (image?.size.height)! / 2
                    newImageWidth = (image?.size.width)! / 2
                } else if (DYNAMICFONTSIZE.IS_IPHONE_6) {
                    newImageHeight = (image?.size.height)! / 2
                    newImageWidth = (image?.size.width)! / 2
                } else if (DYNAMICFONTSIZE.IS_IPHONE_6P) {
                    newImageHeight = (image?.size.height)! / 3
                    newImageWidth = (image?.size.width)! / 3
                }
                let curR = newImageHeight / newImageWidth
                var heightNew : CGFloat
                //let ImgW = image?.size.width ?? 0
                let VImgW = self.eventImageView?.frame.size.width ?? 1
                //let VImgW = newImageWidth ?? 1
                heightNew = curR * VImgW;
                self.eventImageView?.frame = CGRect(x: 0, y: 0, width: VImgW, height: heightNew)
                self.detailview.frame = CGRect(x: self.detailview.frame.origin.x, y: heightNew, width: self.detailview.frame.width, height: self.detailview.frame.height);
                self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.mainView.frame.origin.y, width: self.mainView.frame.width, height: self.detailview.frame.height+heightNew)
                self.shadowview.frame = CGRect(x: self.shadowview.frame.origin.x, y: self.shadowview.frame.origin.y, width: self.shadowview.frame.width, height: self.shadowview.frame.height+heightNew+5)
                
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.detailview.frame.height+heightNew+10)
                
                self.eventImageView?.image = image
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CellDidLoadImageDidLoadNotification"), object: self)
                
                
                
            }
            
        })
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
