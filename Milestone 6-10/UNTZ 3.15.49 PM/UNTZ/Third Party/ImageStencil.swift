//
//  ImageStencil.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 15/09/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit



class ImageStencil: UIImageView {
    var whiteView: UIView!
    var gradLayer: CALayer!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
    }
    func startAnimationOfImage(animation:Bool){
        if(whiteView==nil){
            let color : UIColor =  UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
            self.backgroundColor = color
            self.layer.removeAllAnimations()
            
            if self.layer.sublayers != nil {
                for i in (0..<self.layer.sublayers!.count)
                {
                    let layer : CALayer = self.layer.sublayers![i]
                    layer.removeFromSuperlayer()
                }
            }
            
//            for layer : CALayer? in self.layer.sublayers!{
//                if layer != nil {
//                    layer?.removeFromSuperlayer()
//                }            }
            let h:CGFloat = self.bounds.height
            let w:CGFloat = self.bounds.width
            let frame = CGRect(x: 0, y: (self.bounds.height-h)/2, width: w, height: h)
            if (animation) {
              gradLayer = CALayer()
              gradLayer.frame = frame
              gradLayer.backgroundColor = color.cgColor;
              self.layer.addSublayer(gradLayer)
                
              let  animColor = self.darkerColorForColor(color: color)
                whiteView = UIView(frame: frame)
                whiteView.backgroundColor = animColor
                whiteView.isUserInteractionEnabled = false
                self.addSubview(whiteView)
                
                let maskLayer:CALayer = CALayer()
                maskLayer.backgroundColor = animColor.cgColor
                maskLayer.contentsGravity = kCAGravityCenter
                maskLayer.frame = CGRect(x: -whiteView.frame.size.width, y: 0, width: whiteView.frame.size.width, height: whiteView.frame.size.height)
                
                let maskAnim = CABasicAnimation(keyPath: "position.x")
                maskAnim.byValue = NSNumber(value: Float(whiteView.frame.size.width*9))
                maskAnim.repeatCount = Float.infinity
                maskAnim.duration = 3
                maskLayer.add(maskAnim, forKey: "shineAnim")
                whiteView.layer.mask = maskLayer
                
            }
            
        }
    }
    func darkerColorForColor(color : UIColor) -> UIColor{
        var red:   CGFloat = 0
        var green: CGFloat = 0
        var blue:  CGFloat = 0
        var alpha: CGFloat = 0
        
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha){
            return UIColor(red:max(red - 0.2, 0.0), green:max(green - 0.2, 0.0) ,blue:max(red - 0.2, 0.0) , alpha:0.5)
        }
        return .clear
        
    }
    func stopAnimationOfImage(){
        if (whiteView != nil) && whiteView.isDescendant(of: self) {
            whiteView.removeFromSuperview()
            whiteView = nil
        }
        self.backgroundColor = .clear
        if self.layer.sublayers != nil {
        for layer : CALayer! in self.layer.sublayers!{
            // Do what you want to do with the subview
            if layer != nil {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
