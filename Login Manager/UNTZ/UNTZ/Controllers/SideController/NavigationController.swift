//
//  NavigationController.swift
//  LGSideMenuControllerDemo
//

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
    }

//    override var shouldAutorotate : Bool {
//        return true
//    }
//    
//    override var prefersStatusBarHidden : Bool {
//        return false //UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
//    }
//    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
//
//    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
//        return sideMenuController!.isRightViewVisible ? .slide : .fade
//    }

}
