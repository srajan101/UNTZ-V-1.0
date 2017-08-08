//
//  UNButton.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 17/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UNButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init() {
        super.init(frame: UIScreen.main.bounds);
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let fontsize:Float = Float(self.titleLabel!.font.pointSize * DYNAMICFONTSIZE.SCALE_FACT_FONT)
        self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: CGFloat(fontsize))

    }

}
