//
//  FilterTableViewCell.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 01/05/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet weak var chkboxImageView: UIImageView!
    @IBOutlet weak var filterLabel: UNLabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
