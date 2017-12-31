//
//  CustomNavBar.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 12/09/17.
//  Copyright © 2017 The MobileWallet. All rights reserved.
//

import Foundation
import UIKit

typealias backHandler = ()  -> Void
typealias rightButtonHandler = ()  -> Void

func addCustomNavBar(_ self : UIViewController, isMenuRequired: Bool, title: String, isTranslucent:Bool? = false , hidesBackButton:Bool? = false, backhandler: @escaping backHandler) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    // Set navigation bar background colour
   
    let color = UIColor.init(red: 190/255, green: 20/255, blue: 17/255, alpha: 1.0)
    
    self.navigationController!.navigationBar.barTintColor =  color
    
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController!.navigationBar.shadowImage = UIImage()
    self.navigationController!.navigationBar.isTranslucent = isTranslucent ?? false
    // MARK:- left item-back button
    let button = ActionButton(frame: CGRect(x: -10, y: 0, width: 30, height: 44))
    button.touchUp = { button in
        backhandler()
    }
    let barButton = UIBarButtonItem.init(customView: button)
    
    if isMenuRequired {
        button.setImage(UIImage.init(named: "menu"), for: UIControlState.normal)
    }else{
        button.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
        
    }
    
    self.navigationItem.leftBarButtonItems = [barButton]
    self.navigationItem.title = title
    self.navigationItem.hidesBackButton = hidesBackButton!
}

func addPersonalizeNavBar(_ self : UIViewController, leftButtonTitle:String?, rightButtonTitle:String?,rightButtonImage:String?, title: String, isTranslucent:Bool? = false , hidesBackButton:Bool? = false, isMenuRequired: Bool? = false, backhandler: @escaping backHandler,rightButtonHandler: @escaping rightButtonHandler) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    // Set navigation bar background colour
    
    let color = UIColor.init(red: 190/255, green: 20/255, blue: 17/255, alpha: 1.0)
    
    self.navigationController!.navigationBar.barTintColor =  color
    
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController!.navigationBar.shadowImage = UIImage()
    self.navigationController!.navigationBar.isTranslucent = isTranslucent ?? false
    // MARK:- left item-back button
    let leftButton = ActionButton(frame: CGRect(x: -10, y: 0, width: 30, height: 44))
    leftButton.touchUp = { button in
        backhandler()
    }

    if(isMenuRequired)! {
        leftButton.setImage(UIImage.init(named: "menu"), for: UIControlState.normal)

    } else {
        if let leftButtonTitle = leftButtonTitle {
            leftButton.frame.size = CGSize.init(width: 60, height: 40)
            leftButton.setTitle(leftButtonTitle, for: .normal)
            leftButton.setTitleColor(UIColor.white, for: .normal)
            
        }else{
            leftButton.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
        }

    }
    
    
    let leftBarButton = UIBarButtonItem.init(customView: leftButton)
    if hidesBackButton == true {
        self.navigationItem.hidesBackButton = true
    // Hide BAck Button
    } else {
        self.navigationItem.leftBarButtonItems = [leftBarButton]
    }

    self.navigationItem.title = title
    
        // MARK:- right item-back button
        let rightButton = ActionButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        
        if let rightButtonTitle = rightButtonTitle {
            rightButton.frame.size = CGSize.init(width: 70, height: 40)

            rightButton.setTitle(rightButtonTitle, for: .normal)
            rightButton.setTitleColor(UIColor.white, for: .normal)
            //rightButton.titleLabel?.font = CustomFont(font: .regular(12.5))
            
        }
        
        if let rightButtonImage = rightButtonImage {
            let image = UIImage.init(named: rightButtonImage)
            rightButton.setImage(image, for: .normal)
        }
        rightButton.touchUp = { button in
            rightButtonHandler()
        }
        let rightBarButton = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.hidesBackButton = hidesBackButton!
        self.navigationItem.rightBarButtonItems = [rightBarButton]
        
    
    
}

// MARK:-Hooking up UIButton to closure
class ActionButton: UIButton {
    
    var touchUp: ((_ button: UIButton) -> ())?
    
    //required init?(coder aDecoder: NSCoder) { fatalError("init(coder:)") }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    func setupButton() {
        //this is my most common setup, but you can customize to your liking
        addTarget(self, action: #selector(touchUp(sender:)), for: [.touchUpInside])
    }
    
    //actions
    func touchUp(sender: UIButton) {
        touchUp?(sender)
    }
    
}


