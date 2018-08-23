//
//  Ruler.swift
//  ARKitExample
//
//  Created by dsl on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
class Ruler: UIViewController {
    
    var gridview = UIView()
    var witdhtocm = CGFloat(0)
    var heighttocm = CGFloat(0)
    var ppivalue = CGFloat(0)
    var viewwidth = CGFloat(0)
    var viewheight = CGFloat(0)
    
    var mmwidth = CGFloat(0)
    var mm = CGFloat(0)
    
    var columnNumber = 0
    var rowNumber = 0
    
    var rowmeasureLayer = UIImageView()
    var columnmeasureLayer = UIImageView()
    var measurePoint = UIImageView()
    
    var xvaluelabel = UILabel()
    var yvaluelabel = UILabel()
    
    var xvalue = CGFloat(0)
    var yvalue = CGFloat(0)
    
    var touchView = UIImageView()
    
    var rowmeasurelayermove :CGFloat?
    var columnmeasurelayermove :CGFloat?
    var measurepointmoveX :CGFloat?
    var measurepointmoveY :CGFloat?
    var touchmoveX :CGFloat?
    var touchmoveY :CGFloat?
    
    var maskView = UIView()
    var exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bounds= \(self.view.bounds)")
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundGrid@2x.png")!)
        self.view.backgroundColor = UIColor(red: 62.0/255, green: 167.0/255, blue: 227.0/255, alpha: 1)
        viewwidth = self.view.bounds.size.width
        viewheight = self.view.bounds.size.height
        
        
        if self.view.bounds.size.height == 480 || self.view.bounds.size.height == 568 || self.view.bounds.size.height == 667{
            ppivalue = 326
            mm = 750.0/326*25.4
            mmwidth = 375.0/(750.0/326*25.4)
            gridview.frame = self.view.bounds;
//            viewheight = self.view.bounds.size.height
        }
        else if self.view.bounds.size.height == 736{
            ppivalue = 401
            mm = 1242/401*25.4
            mmwidth = 414.0/(1242/401*25.4)
            gridview.frame = self.view.bounds
//            viewheight = self.view.bounds.size.height
        }
        else if self.view.bounds.size.height == 812{
            ppivalue = 458
            mm = 1125/458*25.4
            mmwidth = 375.0/(1125/458*25.4)
//            viewheight = viewheight-30-35
            gridview.frame = CGRect(x: 0, y: 30, width: viewwidth, height: viewheight-30-35)
        }
        gridview.backgroundColor = UIColor(red: 62.0/255, green: 167.0/255, blue: 227.0/255, alpha: 1)
        self.view.addSubview(gridview)
        
        
        columnNumber = Int(mm)+1
        rowNumber = Int(viewheight/mmwidth) + 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        addGrid()
        addScale()
        addtext()
        addmeasureLayer()
        adddisplay()
        addexitbutton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
            
            gridview.layer.addSublayer(columnLayer)
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
            
            gridview.layer.addSublayer(rowLayer)
        }
    }
    
    func addScale(){
        for i in 0...columnNumber{
            let scaleLayer = CALayer()
            if i == 0{
                continue
            }
            scaleLayer.frame.origin = CGPoint(x: CGFloat(i)*mmwidth-0.5, y: 0)
            if i%5 == 0 {
                if i%10 == 0{
                    scaleLayer.frame.size = CGSize(width: 1, height: mmwidth*4)
                }
                else{
                    scaleLayer.frame.size = CGSize(width: 1, height: mmwidth*2)
                }
            }
            else{
                scaleLayer.frame.size = CGSize(width: 1, height: mmwidth)
            }
            scaleLayer.backgroundColor = UIColor.white.cgColor
            
            gridview.layer.addSublayer(scaleLayer)
        }
        
        for i in 0...rowNumber{
            let scaleLayer = CALayer()
            if i == 0{
                continue
            }
            scaleLayer.frame.origin = CGPoint(x: 0, y: CGFloat(i)*mmwidth-0.5)
            if i%5 == 0{
                if i%10 == 0{
                    scaleLayer.frame.size = CGSize(width: mmwidth*4, height: 1)
                }
                else{
                    scaleLayer.frame.size = CGSize(width: mmwidth*2, height: 1)
                }
            }
            else{
                scaleLayer.frame.size = CGSize(width: mmwidth, height: 1)
            }
            scaleLayer.backgroundColor = UIColor.white.cgColor
            
            gridview.layer.addSublayer(scaleLayer)
        }
    }
    
    func addtext(){
        
        for i in 0...columnNumber{
            let textlayer = UILabel()
            textlayer.textColor = UIColor.white
            textlayer.font = UIFont.boldSystemFont(ofSize: 15)
            textlayer.textAlignment = NSTextAlignment.center
//            textlayer.allowsEdgeAntialiasing = true
            if i == 0{
                continue
            }
            textlayer.frame.size = CGSize(width: mmwidth*3, height: mmwidth*3)
            
            if i%5 == 0{
                if i%10 == 0{
                    textlayer.frame.origin = CGPoint(x: CGFloat(i)*mmwidth-mmwidth*3/2, y: mmwidth*5)
                    textlayer.text = NSString(format: "%d", Int(i/10)) as String
                    gridview.addSubview(textlayer)
                }
            }
            
        }
        for i in 0...rowNumber{
            let textlayer = UILabel()
            textlayer.textColor = UIColor.white
            textlayer.font = UIFont.boldSystemFont(ofSize: 15)
            textlayer.textAlignment = NSTextAlignment.center
//            textlayer.allowsEdgeAntialiasing = true
            textlayer.layer.transform = CATransform3DMakeRotation(.pi/2, 0, 0, 1)
            if i == 0{
                continue
            }
            textlayer.frame.size = CGSize(width: mmwidth*3, height: mmwidth*3)
            if i%5 == 0{
                if i%10 == 0{
                    textlayer.frame.origin = CGPoint(x: mmwidth*5, y: CGFloat(i)*mmwidth-mmwidth*3/2)
                    textlayer.text = NSString(format: "%d", Int(i/10)) as String
                    gridview.addSubview(textlayer)
                }
            }

        }
        
    }
    
    func addmeasureLayer(){
        rowmeasureLayer.frame = CGRect(x: 0, y: viewheight/2-4, width: viewwidth, height: 8)
        rowmeasureLayer.image =  UIImage(named: "ButtonIndicatorRulerRight@2x.png")!
        gridview.addSubview(rowmeasureLayer)
        
        columnmeasureLayer.frame = CGRect(x: viewwidth/2-4, y: 0, width: 8, height: viewheight)
        columnmeasureLayer.image = UIImage(named: "ButtonIndicatorRulerTop@2x.png")!
        gridview.addSubview(columnmeasureLayer)
        
        measurePoint.frame = CGRect(x: viewwidth/2-10, y: viewheight/2-10, width: 20, height: 20)
        measurePoint.image = UIImage(named: "ruleraim@2x.png")
        gridview.addSubview(measurePoint)
        
        maskView.frame = CGRect(x: 0, y: 0, width: viewwidth/2, height: viewheight/2)
        maskView.backgroundColor = UIColor.blue
        maskView.alpha = 0.1
//        gridview.addSubview(maskView)
        gridview.insertSubview(maskView, at: 1)
    }
    
    func adddisplay(){
        xvalue = (viewwidth/mmwidth*0.5)/10
        yvalue = (viewheight/mmwidth*0.5)/10
        xvaluelabel.frame = CGRect(x: viewwidth/2-60, y: viewheight-40-30, width: 60, height: 30)
        xvaluelabel.text = NSString(format: "%.2fcm,", xvalue) as String
        xvaluelabel.textAlignment = NSTextAlignment.center
        xvaluelabel.textColor = UIColor.white
        xvaluelabel.font = UIFont.systemFont(ofSize: 15)
        gridview.addSubview(xvaluelabel)
        
        yvaluelabel.frame = CGRect(x: viewwidth/2, y: viewheight-40-30, width: 60, height: 30)
        yvaluelabel.text = NSString(format: "%.2fcm", yvalue) as String
        yvaluelabel.textAlignment = NSTextAlignment.center
        yvaluelabel.textColor = UIColor.white
        yvaluelabel.font = UIFont.systemFont(ofSize: 15)
        gridview.addSubview(yvaluelabel)
        
        touchView.frame = CGRect(x: viewwidth/2, y: viewheight/2, width: 60, height: 60)
        touchView.image = UIImage(named: "rulerhandle@2x.png")
        touchView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        touchView.addGestureRecognizer(pan)
        gridview.addSubview(touchView)
        
        
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
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pan(sender: UIPanGestureRecognizer){
        //        let innerPoint = sender.location(in: touchView)
        //        let point = sender.location(in: gridview)
        let point = sender.translation(in: gridview)
        print("point->\(point)  ")
        switch sender.state {
        case .began:
            do {
                rowmeasurelayermove = rowmeasureLayer.frame.origin.y
                columnmeasurelayermove = columnmeasureLayer.frame.origin.x
                measurepointmoveX = measurePoint.frame.origin.x
                measurepointmoveY = measurePoint.frame.origin.y
                touchmoveX = touchView.frame.origin.x
                touchmoveY = touchView.frame.origin.y
        }
            break
        case .changed: do {
            rowmeasureLayer.frame = CGRect(x: 0, y: point.y+rowmeasurelayermove!, width: viewwidth, height: 8)
            columnmeasureLayer.frame = CGRect(x: point.x+columnmeasurelayermove!, y: 0, width: 8, height: viewheight)
            measurePoint.frame = CGRect(x: point.x+measurepointmoveX!, y: point.y+measurepointmoveY!, width: 20, height: 20)
            if viewheight == 812{
                //TODO: 这里要修改
//                if point.y+rowmeasurelayermove!+4 >= viewheight-40-3 || point.x+columnmeasurelayermove!+4 >= viewwidth || point.y + rowmeasurelayermove!+4 <= 0 || point.x + columnmeasurelayermove!+4 <= 0{
//
//                }
                if point.y+rowmeasurelayermove!+4 >= viewheight-40-30{
                    rowmeasureLayer.frame.origin.y = viewheight-40-30-4
                    measurePoint.frame.origin.y = viewheight-40-30-10
                }
                if point.x+columnmeasurelayermove!+4 >= viewwidth{
                    columnmeasureLayer.frame.origin.x = viewwidth - 4
                    measurePoint.frame.origin.x = viewwidth-10
                }
                if point.y + rowmeasurelayermove!+4 <= 0{
                    rowmeasureLayer.frame.origin.y  = -4.0
                    measurePoint.frame.origin.y = -10.0
                }
                if point.x + columnmeasurelayermove!+4 <= 0{
                    columnmeasureLayer.frame.origin.x = -4.0
                    measurePoint.frame.origin.x = -10.0
                }
            }
            else{
                if point.y+rowmeasurelayermove!+4 >= viewheight{
                    rowmeasureLayer.frame.origin.y = viewheight - 4
                    measurePoint.frame.origin.y = viewheight-10
                }
                if point.x+columnmeasurelayermove!+4 >= viewwidth{
                    columnmeasureLayer.frame.origin.x = viewwidth - 4
                    measurePoint.frame.origin.x = viewwidth-10
                }
                if point.y + rowmeasurelayermove!+4 <= 0{
                    rowmeasureLayer.frame.origin.y  = -4.0
                    measurePoint.frame.origin.y = -10.0
                }
                if point.x + columnmeasurelayermove!+4 <= 0{
                    columnmeasureLayer.frame.origin.x = -4.0
                    measurePoint.frame.origin.x = -10.0
                }
                
            }
            
            
            
            touchView.frame = CGRect(x: point.x+touchmoveX!, y: point.y+touchmoveY!, width: 60, height: 60)
            xvalue = ((columnmeasureLayer.frame.origin.x+4)/mmwidth)/10
            yvalue = ((rowmeasureLayer.frame.origin.y+4)/mmwidth)/10
            xvaluelabel.text = NSString(format: "%.2fcm,", xvalue) as String
            yvaluelabel.text = NSString(format: "%.2fcm", yvalue) as String
            maskView.frame = CGRect(x: 0, y: 0, width: columnmeasureLayer.frame.origin.x+4, height: rowmeasureLayer.frame.origin.y+4)
            
            if columnmeasureLayer.frame.origin.x > viewwidth*4/5{
                touchView.frame.origin.x = columnmeasureLayer.frame.origin.x-60
//                touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                touchView.image = UIImage(named: "rulerhandle@2x.png")
                touchView.layer.transform = CATransform3DMakeTranslation(-60, 0, 0)
                touchView.layer.transform = CATransform3DMakeScale(-1, 1, 1)
                
                
                if rowmeasureLayer.frame.origin.y < viewheight*1/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                    touchView.image = UIImage(named: "rulerhandle@2x.png")
//                    touchView.layer.transform = CATransform3DIdentity
//                    touchView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
                    
//                    touchView.layer.transform = CATransform3DMakeTranslation(-60, 0, 0)
//                    touchView.layer.transform = CATransform3DMakeScale(-1, 1, 1)
                }
                else if rowmeasureLayer.frame.origin.y > viewheight*4/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y - 60
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y-60, width: 60, height: 60)
//                    touchView.layer.transform = CATransform3DIdentity
                    touchView.image = UIImage(named: "rulerhandle@2x.png")
//                    touchView.layer.transform = CATransform3DIdentity
                    touchView.layer.transform = CATransform3DMakeTranslation(-60, -60, 0)
                    touchView.layer.transform = CATransform3DMakeScale(-1, -1, 1)
                    
                }
                else{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
//                    touchView.layer.transform = CATransform3DIdentity
                }
            }
            else if columnmeasureLayer.frame.origin.x < viewwidth*1/5{
                touchView.frame.origin.x = columnmeasureLayer.frame.origin.x
                //                touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                touchView.image = UIImage(named: "rulerhandle@2x.png")
//                touchView.layer.transform = CATransform3DMakeTranslation(-60, 0, 0)
//                touchView.layer.transform = CATransform3DMakeScale(-1, 1, 1)
                touchView.layer.transform = CATransform3DIdentity
                
                if rowmeasureLayer.frame.origin.y < viewheight*1/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                    touchView.image = UIImage(named: "rulerhandle@2x.png")
                    touchView.layer.transform = CATransform3DIdentity
//                    touchView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
                }
                else if rowmeasureLayer.frame.origin.y > viewheight*4/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y - 60
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x, y: rowmeasureLayer.frame.origin.y-60, width: 60, height: 60)
                    touchView.image = UIImage(named: "rulerhandle@2x.png")
//                    touchView.layer.transform = CATransform3DIdentity
                    
                    touchView.layer.transform = CATransform3DMakeTranslation(0, -60, 0)
                    touchView.layer.transform = CATransform3DMakeScale(1, -1, 1)
                }
                else{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                    touchView.layer.transform = CATransform3DIdentity
                }
            }
            else{
                touchView.frame.origin.x = columnmeasureLayer.frame.origin.x
                
                touchView.image = UIImage(named: "rulerhandle@2x.png")
                touchView.layer.transform = CATransform3DIdentity
                
                if rowmeasureLayer.frame.origin.y < viewheight*1/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
                    touchView.image = UIImage(named: "rulerhandle@2x.png")
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                    //                    touchView.image = UIImage(named: "rulerhandle@2x.png")
                    touchView.layer.transform = CATransform3DIdentity
                    //                    touchView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
                }
                else if rowmeasureLayer.frame.origin.y > viewheight*4/5{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y - 60
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x-60, y: rowmeasureLayer.frame.origin.y-60, width: 60, height: 60)
                    touchView.layer.transform = CATransform3DIdentity
                    touchView.layer.transform = CATransform3DMakeTranslation(0, -60, 0)
                    touchView.layer.transform = CATransform3DMakeScale(1, -1, 1)
                    
                }
                else{
                    touchView.frame.origin.y = rowmeasureLayer.frame.origin.y
//                    touchView.frame = CGRect(x: columnmeasureLayer.frame.origin.x, y: rowmeasureLayer.frame.origin.y, width: 60, height: 60)
                    touchView.layer.transform = CATransform3DIdentity
                }
            }
        }
            break
        case .cancelled:fallthrough
        case .ended:fallthrough
        case .failed:do {
            
        }
            break
        default: break
            
        }

        
        
    }
}
