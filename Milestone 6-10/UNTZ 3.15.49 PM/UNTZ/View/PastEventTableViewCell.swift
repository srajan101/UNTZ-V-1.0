//
//  UpcomingEventTableViewCell.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 21/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PastEventTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var userNamestatusLable: UNLabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let buttonImage = UIImage(named: "star")
//        interestedBtn.setImage(buttonImage, for: .normal)
//        interestedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0)
//        interestedBtn.layer.cornerRadius = 3.5;
//        interestedBtn.layer.borderWidth = 1;
//        interestedBtn.layer.borderColor = UIColor.red.cgColor
        
        profileImageview.layer.cornerRadius = profileImageview.frame.size.height/2
        profileImageview.clipsToBounds = true

        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 5
        shadowview.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
