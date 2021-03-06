//
//  WhatshappeningCell.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 15/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class WhatshappeningCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        /*
        if (selected) {
            nameLabel.textColor = UIColor.lightGray
        } else {
            nameLabel.textColor = UIColor.black
        }
        */
    }
    
    //var myLabel = UILabel()
    var shadowview = UIView()
    var parentview = UIView()
    //var profileview = ImageStencil(image:nil)
    var profileview = UIImageView()
    var timeLabel = UNLabel()
    var nameLabel = UNLabel()
    var reqLabel = UNLabel()
    var trackNameLabel = UNLabel()
    var deleteButton = UNButton()
    var acceptButton = UNButton()
    var desTextLabel = UNLabel()
    var linkImageview = ImageStencil(image:nil)
    var imageContainer = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    func generateRequestViews(postcommentObj : RequestedTrackInfo) {
        self.contentView.backgroundColor = UIColor.clear
        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 5
        shadowview.backgroundColor = UIColor.clear
        self.contentView.addSubview(shadowview)
        
        //parentview.layer.cornerRadius = 5.0
        //parentview.clipsToBounds = true
        parentview.backgroundColor = UIColor.white
        self.shadowview.addSubview(parentview)
        
        profileview.layer.cornerRadius = 20
        profileview.backgroundColor = UIColor.white
        profileview.clipsToBounds = true
        self.parentview.addSubview(profileview)
        
        linkImageview.backgroundColor = UIColor.clear
        linkImageview.clipsToBounds = true
        self.parentview.addSubview(linkImageview)
        
        timeLabel.textColor = UIColor(red: 137.0/255.0, green: 149.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        timeLabel.text = self.timediffernce(dateStr: postcommentObj.requestDateTime!)
        timeLabel.font =  UIFont(name: "Roboto-Regular", size: 14)
        self.parentview.addSubview(timeLabel)
        
        //trackNameLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        trackNameLabel.textColor = UIColor.darkGray
        trackNameLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(trackNameLabel)
        
        nameLabel.textColor = UIColor.black
        nameLabel.text = ""
        nameLabel.font =  UIFont(name: "Roboto-Bold", size: 15)
        self.parentview.addSubview(nameLabel)
        
        reqLabel.textColor = UIColor.black
        reqLabel.text = "Made Request for song"
        reqLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(reqLabel)
        
        
        desTextLabel.textColor = UIColor(red: 137.0/255.0, green: 149.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        desTextLabel.text = "" //write comment request for song
        desTextLabel.numberOfLines = 0
        desTextLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(desTextLabel)
        
        let results = postcommentObj.eventTrackArtistsInfoList!
        var nameList:String = ""
        
        for i in (0..<results.count)
        {
            let name : String =    (postcommentObj.eventTrackArtistsInfoList?[i].eventTrackName)!
            if i>0 {
                nameList = nameList + "-"
            }
            nameList = nameList + name
        }
        
        desTextLabel.text = nameList
        
        deleteButton.setImage(UIImage(named: "deleteBtn"), for: .normal)
        self.parentview.addSubview(deleteButton)
        
        acceptButton.setImage(UIImage(named: "acceptBtn"), for: .normal)
        self.parentview.addSubview(acceptButton)
        let xVal = 10;
        var width_val : CGFloat
        var height_val : CGFloat
        
        width_val = self.frame.size.width - (2*CGFloat(xVal))
        shadowview.frame = CGRect(x: CGFloat(xVal), y: 0, width: width_val, height: self.frame.size.height)
        parentview.frame = CGRect(x: 0, y: 0, width: width_val, height: shadowview.frame.size.height-CGFloat(xVal))
        profileview.frame = CGRect(x: CGFloat(xVal), y: CGFloat(xVal), width: 40, height: 40)
        reqLabel.frame = CGRect(x: CGFloat(xVal), y: CGFloat(xVal)+40, width: 240, height: 30)
        let widthdatelbl = self.width(string: timeLabel.text! as NSString, withConstraintedHeight: 16, font: timeLabel.font!)
        //timeLabel.frame = CGRect(x: width_val-(15+widthdatelbl), y: CGFloat(xVal), width: widthdatelbl, height: 16)
        
        let widthnamelbl =  width_val - (profileview.frame.origin.x+40+10+10+widthdatelbl+15)
        
        nameLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: CGFloat(xVal), width: widthnamelbl, height: 18)
        timeLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: CGFloat(xVal)+18, width: widthnamelbl+30, height: 18)
        
        height_val = profileview.frame.size.height + CGFloat(xVal) + 30
        linkImageview.frame = CGRect(x: CGFloat(xVal), y: height_val, width: 40, height: 40)
        trackNameLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: height_val, width: width_val-(profileview.frame.origin.x+40+10), height: 20)
        linkImageview.isHidden = false
        acceptButton.isHidden = false
        deleteButton.isHidden = false
        reqLabel.isHidden = false
        height_val += 20
        
        let heightdeslbl = self.height(string: desTextLabel.text! as NSString, withConstrainedWidth: width_val - (profileview.frame.origin.x+40+10), font: desTextLabel.font!)
        desTextLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: height_val, width: width_val - (profileview.frame.origin.x+40+10), height: heightdeslbl)
        
        height_val += heightdeslbl + 20;
        deleteButton.frame = CGRect(x: Int((width_val-20) - CGFloat(xVal)), y: xVal, width: 21, height: 28)
        acceptButton.frame = CGRect(x: Int((width_val-20) - (CGFloat(xVal)+15+25)), y: xVal+5, width: 26, height: 20)
    }
    
    func generateViews(postcommentObj : PostCommentsInfo) {
        //self.contentView.addSubview(myLabel)
        self.contentView.backgroundColor = UIColor.clear
        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 5
        shadowview.backgroundColor = UIColor.clear
        self.contentView.addSubview(shadowview)
        
        //parentview.layer.cornerRadius = 5.0
        //parentview.clipsToBounds = true
        parentview.backgroundColor = UIColor.white
        self.shadowview.addSubview(parentview)
        
        profileview.layer.cornerRadius = 20
        profileview.backgroundColor = UIColor.white
        profileview.clipsToBounds = true
        self.parentview.addSubview(profileview)
        
        linkImageview.backgroundColor = UIColor.blue
        linkImageview.clipsToBounds = true
        self.parentview.addSubview(linkImageview)
        
        //imageContainer.backgroundColor = UIColor.blue
        self.parentview.addSubview(imageContainer)
        
        trackNameLabel.textColor = UIColor(red: 137.0/255.0, green: 149.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        trackNameLabel.text = ""
        //trackNameLabel.isHidden = true
        trackNameLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(trackNameLabel)
        
        reqLabel.textColor = UIColor.black
        reqLabel.isHidden = true
        reqLabel.text = ""
        reqLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(reqLabel)
        
        timeLabel.textColor = UIColor(red: 137.0/255.0, green: 149.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        timeLabel.text = self.timediffernce(dateStr: postcommentObj.commentTime!)
        timeLabel.font =  UIFont(name: "Roboto-Regular", size: 14)
        self.parentview.addSubview(timeLabel)
        
        nameLabel.textColor = UIColor.black
        nameLabel.text = ""
        nameLabel.font =  UIFont(name: "Roboto-Bold", size: 15)
        self.parentview.addSubview(nameLabel)
        
        desTextLabel.textColor = UIColor.black
        desTextLabel.text = postcommentObj.commentName!
        desTextLabel.numberOfLines = 0
        desTextLabel.font =  UIFont(name: "Roboto-Regular", size: 15)
        self.parentview.addSubview(desTextLabel)
        
        
        deleteButton.setImage(UIImage(named: "deleteBtn"), for: .normal)
        self.parentview.addSubview(deleteButton)
        
        acceptButton.setImage(UIImage(named: "acceptBtn"), for: .normal)
        self.parentview.addSubview(acceptButton)
        
        let xVal = 10;
        var width_val : CGFloat
        var height_val : CGFloat
        
        width_val = self.frame.size.width - (2*CGFloat(xVal))
        shadowview.frame = CGRect(x: CGFloat(xVal), y: 0, width: width_val, height: self.frame.size.height)
        parentview.frame = CGRect(x: 0, y: 0, width: width_val, height: shadowview.frame.size.height-CGFloat(xVal))
        profileview.frame = CGRect(x: CGFloat(xVal), y: CGFloat(xVal), width: 40, height: 40)
        linkImageview.frame = CGRect(x: width_val-(15+60), y: CGFloat(xVal)+20, width: 40, height: 40)
        let widthdatelbl = self.width(string: timeLabel.text! as NSString, withConstraintedHeight: 16, font: timeLabel.font!)
        // timeLabel.frame = CGRect(x: width_val-(15+widthdatelbl), y: CGFloat(xVal), width: widthdatelbl, height: 16)
        
        let widthnamelbl =  width_val - (profileview.frame.origin.x+40+10+10+widthdatelbl+15)
        
        nameLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: CGFloat(xVal), width: widthnamelbl, height: 18)
        timeLabel.frame = CGRect(x: profileview.frame.origin.x+40+10, y: CGFloat(xVal)+18, width: widthnamelbl+30, height: 18)
        height_val = profileview.frame.size.height + CGFloat(xVal) + 10
        
        linkImageview.isHidden = true
        acceptButton.isHidden = true
        
        
        let heightdeslbl = self.height(string: desTextLabel.text! as NSString, withConstrainedWidth: width_val - (2*CGFloat(xVal)), font: desTextLabel.font!)
        desTextLabel.frame = CGRect(x: CGFloat(xVal), y: height_val, width: width_val - (2*CGFloat(xVal)), height: heightdeslbl)
        
        height_val += heightdeslbl + 10;
        let results = postcommentObj.picturesInfoListArray!
        
        let mainwidth = (width_val - (2*CGFloat(xVal)))
        var width1 = mainwidth
        let height1 = 300
        var height2 = height1
        if results.count>1{
            width1 = mainwidth/2;
        }
        
        if results.count>0 {
            
            for i in (0..<results.count)
            {
                if i>5{
                    return
                }
                let childImageview = ImageStencil(image:nil)
                //childImageview.backgroundColor = UIColor.gray
                childImageview.clipsToBounds = true
                childImageview.contentMode = .scaleAspectFill;
                //childImageview.layer.cornerRadius = 5.0
                
                if results.count == 1 {
                    childImageview.frame = CGRect(x: 0, y: 0, width: Int(width1), height:height1)
                }
                if results.count==2 {
                    if i == 0 {
                        childImageview.frame = CGRect(x: 0, y: 0, width: Int(width1), height:height1)
                    }
                    else{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: 0, width: Int(width1), height:height2)
                    }
                    
                }
                if results.count==3 {
                    height2 = (height1/2)-10
                    if i == 0 {
                        childImageview.frame = CGRect(x: 0, y: 0, width: Int(width1), height:height1-15)
                    }
                    else if i == 1{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: 0, width: Int(width1), height:height2)
                    }
                    else{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: height2+5, width: Int(width1), height:height2)
                    }
                }
                if results.count==4 {
                    height2 = (height1/3)-10
                    if i == 0 {
                        childImageview.frame = CGRect(x: 0, y: 0, width: Int(width1), height:height1-20)
                    }
                    else if i == 1{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: 0, width: Int(width1), height:height2)
                    }
                    else if i == 2{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: height2+5, width: Int(width1), height:height2)
                    }
                    else {
                        childImageview.frame = CGRect(x: Int(width1)+5, y: height2+10+height2, width: Int(width1), height:height2)
                    }
                }
                //*
                if results.count>4 {
                    height2 = (height1/2)-10
                    let width2 = mainwidth/3 - 1
                    if i == 0 {
                        childImageview.frame = CGRect(x: 0, y: 0, width: Int(width1), height:height2)
                    }
                    else if i == 1{
                        childImageview.frame = CGRect(x: Int(width1)+5, y: 0, width: Int(width1), height:height2)
                    }
                    else if i == 2{
                        childImageview.frame = CGRect(x: 0, y: height2 + 5, width: Int(width2), height:height2)
                    }
                    else if i == 3{
                        childImageview.frame = CGRect(x: Int(width2)+5, y: height2 + 5, width: Int(width2), height:height2)
                    }
                    else {
                        childImageview.frame = CGRect(x: Int(width2)+5+Int(width2)+5, y: height2 + 5, width: Int(width2), height:height2)
                    }
                }
                //*/
                
                var imgURL : String =    (postcommentObj.picturesInfoListArray?[i].pictureUrl)!
                imgURL.remove(at: imgURL.startIndex)
                let fullURL : String =  APIEndPoints.getwebURL()+imgURL
                print(fullURL)
//                childImageview.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                childImageview.startAnimationOfImage(animation: false)
                childImageview.sd_setImage(with: URL.init(string: fullURL), completed: { (image, error, cacheType, imageURL) in
                    childImageview.stopAnimationOfImage()
                })
                self.imageContainer.addSubview(childImageview)
                
            }
            let count = results.count % 2
            var totalCount : Int
            totalCount = 0
            if(count>0){
                totalCount = Int(results.count/2) + 1
            }else{
                totalCount = results.count/2
            }
            imageContainer.frame = CGRect(x: CGFloat(xVal), y: height_val, width: width_val - (2*CGFloat(xVal)), height: 300)
            height_val += imageContainer.frame.size.height + 10;
        }
        else{
            imageContainer.isHidden = true
        }
        
        deleteButton.frame = CGRect(x: Int((width_val-20) - CGFloat(xVal)), y: xVal, width: 21, height: 28)
        acceptButton.frame = CGRect(x: Int((width_val-20) - (CGFloat(xVal)+15+25)), y: xVal+5, width: 26, height: 20)
        
    }
    func height(string: NSString,withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(string: NSString,withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
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
   
}
