//
//  SuggestedEventsCell.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 18/03/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SuggestedEventsCell: UITableViewCell {

    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var eventNameLable: UNLabel!
    @IBOutlet weak var artistPictImageView: UIImageView!
    //@IBOutlet weak var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Initialization code
        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 2
        shadowview.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 2
        mainView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
