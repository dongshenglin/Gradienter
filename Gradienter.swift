//
//  Gradienter.swift
//  ARKitExample
//
//  Created by dsl on 2018/6/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import CoreMotion

class Gradienter: UIViewController {
    var viewwidth = CGFloat(0)
    var viewheight = CGFloat(0)
    
    var mmwidth = CGFloat(0)
    var mm = CGFloat(0)
    var ppivalue = CGFloat(0)
    var columnNumber = 0
    var rowNumber = 0
    
    var theview1 = UIView()
    var theview2 = UIView()
    var bgview = UIImageView()
    var indicatorview = UIImageView()
    var bgview2 = UIImageView()
    var lowlevelbgView2 = UIImageView()
    var levelbgView2 = UIImageView()
    var indicatorview2 = UIImageView()
    
    var isShowingtheView1 = false
    var isShowingtheView2 = false
    var isShowingView = false
    
    var exitButton = UIButton()
    var motionManager = CMMotionManager()
    
    let shapeLayer = CAShapeLayer()
    var zTheta = Double(0)
    
    var displayLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 62.0/255, green: 167.0/255, blue: 227.0/255, alpha: 1)
        viewwidth = self.view.bounds.size.width
        viewheight = self.view.bounds.size.height
        if self.view.bounds.size.height == 480 || self.view.bounds.size.height == 568 || self.view.bounds.size.height == 667{
            ppivalue = 326
            mm = 750.0/326*25.4
            mmwidth = 375.0/(750.0/326*25.4)
            //            gridview.frame = self.view.bounds;
            //            viewheight = self.view.bounds.size.height
        }
        else if self.view.bounds.size.height == 736{
            ppivalue = 401
            mm = 1242/401*25.4
            mmwidth = 414.0/(1242/401*25.4)
            //            gridview.frame = self.view.bounds
            //            viewheight = self.view.bounds.size.height
        }
        else if self.view.bounds.size.height == 812{
            ppivalue = 458
            mm = 1125/458*25.4
            mmwidth = 375.0/(1125/458*25.4)
            //            viewheight = viewheight-30-35
            //            gridview.frame = CGRect(x: 0, y: 30, width: viewwidth, height: viewheight-30-35)
        }
        columnNumber = Int(mm)+1
        rowNumber = Int(viewheight/mmwidth) + 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        motionManager = CMMotionManager.init()
        motionManager.deviceMotionUpdateInterval = 0.01
        updateAccelerometer()
        
        addGrid()
//        addbgviews()
//        addexitbutton()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
        
    }
    
//    var motion: CMDeviceMotion?
//    var error: Error?
    func updateAccelerometer(){
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: OperationQueue.current!) { (motion, error) in
            
            let gravityX = motion?.gravity.x
            let gravityY = motion?.gravity.y
            let gravityZ = motion?.gravity.z
            
            self.zTheta = sqrt(gravityX!*gravityX!+gravityY!*gravityY!)
//            print("zTheta-> \(self.zTheta)")
            
            if !self.isShowingView{
                self.isShowingView = true
                self.addbgviews()
                self.addDisplayLabel()
                self.addexitbutton()
            }
            
            self.theview1.alpha = CGFloat((self.zTheta-0.8)*20)
            self.theview2.alpha = 1.0 - CGFloat((self.zTheta-0.8)*20)
            self.indicatorview.layer.transform = CATransform3DMakeRotation(.pi+atan2(CGFloat(gravityX!),CGFloat(gravityY!)), 0, 0, 1)
            self.indicatorview2.center = CGPoint(x:self.viewwidth/2-CGFloat(gravityX!*50), y:self.viewheight/2+CGFloat(gravityY!*50))
            let xVlaue = gravityX!*(.pi/2)*180.0/(.pi)
            let yValue = gravityY!*(.pi/2)*180.0/(.pi)
            self.displayLabel.text = String(format: "X: %.1f°, Y: %.1f°", fabs(xVlaue),fabs(yValue))
        }
    }
    
    func addGrid(){
        
        for i in 0...columnNumber{
            let columnLayer = CALayer()
            columnLayer.frame.size = CGSize(width: 1, height: viewheight)
            columnLayer.frame.origin = CGPoint(x: CGFloat(i)*mmwidth-0.5, y: 0)
            if i%5 == 0{
                columnLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.5).cgColor
            }
            else{
                columnLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.2).cgColor
            }
            
            self.view.layer.addSublayer(columnLayer)
        }
        
        for i in 0...rowNumber{
            let rowLayer = CALayer()
            rowLayer.frame.size = CGSize(width: viewwidth, height: 1)
            rowLayer.frame.origin = CGPoint(x: 0, y: CGFloat(i)*mmwidth-0.5)
            if i%5 == 0{
                rowLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.5).cgColor
            }
            else{
                rowLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.2).cgColor
            }
            
            self.view.layer.addSublayer(rowLayer)
        }
    }
    
    func addexitbutton(){
        exitButton = UIButton(type: UIButtonType.custom)
        if viewheight > 736{
            exitButton.frame = CGRect(x: viewwidth-20-40, y: viewheight-40-35-20, width: 25, height: 25)
        }
        else{
            exitButton.frame = CGRect(x: viewwidth-40-20, y: viewheight-40-20, width: 25, height: 25)
        }
        exitButton.setImage(UIImage(named: "rulerExit@2x.png"), for: UIControlState.normal)
        exitButton.addTarget(self, action: #selector(exitButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(exitButton)
    }
    
    @objc func exitButtonClicked(sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addbgviews(){
//        if zTheta > 0.5{
            theview1 = UIView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            theview1.backgroundColor = UIColor.clear
//            theview1.alpha = CGFloat((zTheta-0.5)*100)
            self.view.addSubview(theview1)
            
            bgview = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            bgview.image = UIImage(named: "OverlayLevel2Mark@2x.png")
            //        bgview.contentMode = UIViewContentMode(rawValue: UIViewContentMode.RawValue(UInt8(UIViewContentMode.left.rawValue)|UInt8(UIViewContentMode.center.rawValue)))!
            bgview.contentMode = UIViewContentMode.center
            theview1.addSubview(bgview)
            
            indicatorview = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            indicatorview.image = UIImage(named: "OverlayLevelIndicator@2x.png")
            indicatorview.contentMode = UIViewContentMode.center
            theview1.addSubview(indicatorview)
            //        indicatorview.layer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)
//        }
//        else{
            theview2 = UIView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            theview2.backgroundColor = UIColor.clear
//            theview2.alpha = CGFloat((0.5-zTheta)*100)
            self.view.addSubview(theview2)
            
            lowlevelbgView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            lowlevelbgView2.image = UIImage(named: "BackgroundLevel2nd@2x.png")
            //        bgview.contentMode = UIViewContentMode(rawValue: UIViewContentMode.RawValue(UInt8(UIViewContentMode.left.rawValue)|UInt8(UIViewContentMode.center.rawValue)))!
            lowlevelbgView2.contentMode = UIViewContentMode.center
            theview2.addSubview(lowlevelbgView2)
            
            indicatorview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            indicatorview2.image = UIImage(named: "ball@2x.png")
            indicatorview2.contentMode = UIViewContentMode.center
            theview2.addSubview(indicatorview2)
            
            bgview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            bgview2.image = UIImage(named: "OverlayLevelGlass@2x.png")
            //        bgview.contentMode = UIViewContentMode(rawValue: UIViewContentMode.RawValue(UInt8(UIViewContentMode.left.rawValue)|UInt8(UIViewContentMode.center.rawValue)))!
            bgview2.contentMode = UIViewContentMode.center
            theview2.addSubview(bgview2)
            
            levelbgView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: viewwidth, height: viewheight))
            levelbgView2.image = UIImage(named: "OverlayLevelSight@2x.png")
            levelbgView2.contentMode = UIViewContentMode.center
            theview2.addSubview(levelbgView2)
            
            
            //        indicatorview.layer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)
//        }
    }
    
    func addDisplayLabel(){
        displayLabel = UILabel(frame: CGRect(x: 0, y: viewheight-40-30+10, width: viewwidth, height: 30))
        displayLabel.textAlignment = NSTextAlignment.center
        displayLabel.font = UIFont.boldSystemFont(ofSize: 15)
        displayLabel.textColor = UIColor.white
        displayLabel.text = String(format: "X: %.1f°, Y: %.1f°", 0.0,0.0)
        self.view.addSubview(displayLabel)
    }
}
