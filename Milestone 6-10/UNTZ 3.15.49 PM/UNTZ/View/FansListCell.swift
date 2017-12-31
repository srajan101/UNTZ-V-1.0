//
//  FansListCell.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 14/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FansListCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var addfanBtn: UIButton!
    @IBOutlet weak var profileImageView : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 5
        shadowView.backgroundColor = UIColor.clear
        
        parentView.layer.cornerRadius = 5.0
        parentView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
