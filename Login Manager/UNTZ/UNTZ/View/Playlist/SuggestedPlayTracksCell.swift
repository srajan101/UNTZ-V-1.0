//
//  SuggestedPlayTracksCell.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 05/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SuggestedPlayTracksCell: UITableViewCell {

    @IBOutlet weak var trackImageV: UIImageView!
    @IBOutlet weak var trackTitleLbl: UILabel!
    @IBOutlet weak var artistNameLbl: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var likeCntLbl: UILabel!
    
    @IBOutlet weak var LikeBtn: UIButton!
    
    @IBOutlet weak var spotifyBtn: UIButton!
    @IBOutlet weak var spotifyBtnWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
