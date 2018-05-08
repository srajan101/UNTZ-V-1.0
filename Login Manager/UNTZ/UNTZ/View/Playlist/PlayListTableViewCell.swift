//
//  PlayListTableViewCell.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 23/01/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PlayListTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImageV: UIImageView!
    @IBOutlet weak var trackTitleLbl: UILabel!
    @IBOutlet weak var artistNameLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var likeCntLbl: UILabel!
    
    @IBOutlet weak var LikeBtn: UIButton!
    
    @IBOutlet weak var spotifyBtn: UIButton!
    @IBOutlet weak var spotifyBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var spotifyBtnSideSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
