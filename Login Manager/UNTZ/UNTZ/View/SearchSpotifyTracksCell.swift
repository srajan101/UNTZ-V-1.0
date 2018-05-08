//
//  SerachSpotifyTracksCell.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 22/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class SearchSpotifyTracksCell: UITableViewCell {
    @IBOutlet weak var requestImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UNLabel!
    @IBOutlet weak var artistLabel: UNLabel!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var playInSpotifyButton: UIButton!
    @IBOutlet weak var shadowview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //requestButton.layer.cornerRadius = 10.0
        //requestButton.layer.masksToBounds = true
        requestButton.layer.cornerRadius = requestButton.frame.size.height / 2
        requestButton.layer.masksToBounds = true
        requestButton.layer.borderWidth = 1.0
        requestButton.layer.borderColor = UIColor.init(hex: "#289DCC").cgColor
        
        playInSpotifyButton.layer.cornerRadius = playInSpotifyButton.frame.size.height / 2
        playInSpotifyButton.layer.masksToBounds = true
        playInSpotifyButton.layer.borderWidth = 1.0
        playInSpotifyButton.layer.borderColor = UIColor.init(hex: "#289DCC").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
