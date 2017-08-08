//
//  EMUIApplicationExtension.swift
//  Enmoji
//
//  Created by Mahesh on 20/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

let storyboard_R1 = UIStoryboard(name: ((UIDevice.current.userInterfaceIdiom == .pad) ? "Main" : "Main" ), bundle: nil)

let storyboard_R2 = UIStoryboard(name: ((UIDevice.current.userInterfaceIdiom == .pad) ? "Main_R2" : "Main_R2" ), bundle: nil)


extension NSObject {
    
    // MARK: - Storyboard operations
    public func makeStoryObj(storyboard : UIStoryboard, Identifier identifier : String) -> UIViewController{
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    public func pushStoryObj(obj : UIViewController, on vc: UIViewController){
        return (vc.navigationController?.pushViewController(obj, animated: true))!
    }
    
    public func pushStory(storyboard : UIStoryboard, identifier : String, on vc: UIViewController){
        vc.navigationController?.pushViewController(makeStoryObj(storyboard: storyboard, Identifier: identifier), animated: true)
    }            
}
