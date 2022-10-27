//
//  ViewController.swift
//  FloatingWindowWithReSize
//
//  Created by Arif on 27/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fullscreen: UIButton!
    @IBOutlet weak var heightconstain: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rect: UIView!
    var touchStart = CGPoint.zero
    var proxyFactor = CGFloat(10)
    var resizeRect = ResizeRect()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rect.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func closeFloatingWindow(_ sender: Any) {
        rect.isHidden = true
    }
    @IBAction func FullScreenFloatingWindow(_ sender: Any) {
        resizeRect.isMinimize = false
        if !resizeRect.isfullscreen {
            
            
            resizeRect.oldTopConst = topConstraint.constant
            resizeRect.oldBottomConst = bottomConstraint.constant
            resizeRect.oldLeftConst = leftConstraint.constant
            resizeRect.oldRightConst = rightConstraint.constant
            print("saveConst",resizeRect.oldTopConst)
            topConstraint.constant = 0
            bottomConstraint.constant = 0
            leftConstraint.constant = 0
            rightConstraint.constant = 0
        } else {
            print("aftsaveConst",resizeRect.oldTopConst)
            topConstraint.constant = resizeRect.oldTopConst
            bottomConstraint.constant = resizeRect.oldBottomConst
            leftConstraint.constant = resizeRect.oldLeftConst
            rightConstraint.constant = resizeRect.oldRightConst
            resizeRect.isfullscreen = false
        }
    }
    
    @IBAction func minOrMaxFlotingWindow(_ sender: Any) {
        if !resizeRect.isMinimize{
            resizeRect.isMinimize = true
            fullscreen.isUserInteractionEnabled = false
            let top = topConstraint.constant
            
            topConstraint.constant = top + resizeRect.minmizeHeight
           
        } else {
            resizeRect.isMinimize = false
            let top = topConstraint.constant
            fullscreen.isUserInteractionEnabled = true
            topConstraint.constant = top - resizeRect.minmizeHeight
        }
    }
    @IBAction func openFloatingWindowAction(_ sender: UIButton) {
        rect.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchStart = touch.location(in: self.view)
            print(touchStart)
            
            resizeRect.topTouch = false
            resizeRect.leftTouch = false
            resizeRect.rightTouch = false
            resizeRect.bottomTouch = false
            resizeRect.middelTouch = false
            
            print(rect.frame.minX,"minx")
            print(rect.frame.minY,"miny")
            print(rect.frame.maxX,"maxx")
            print(rect.frame.maxY,"maxy")
            print("lenth",rect.frame.maxX - rect.frame.minX )
            print("height",rect.frame.maxY - rect.frame.minY )
            if !resizeRect.isMinimize{
                resizeRect.minmizeHeight = rect.frame.maxY - rect.frame.minY - 40
            }
            
//            resizeRect.minmizeHeight = rect.frame.maxX - rect.frame.minX
            if  touchStart.y > rect.frame.minY + (proxyFactor*2) &&  touchStart.y < rect.frame.maxY - (proxyFactor*2) &&  touchStart.x > rect.frame.minX + (proxyFactor*2) &&  touchStart.x < rect.frame.maxX - (proxyFactor*2){
                resizeRect.middelTouch = true
                print("middle")
                return
            }
            
            
            
            if touchStart.y > rect.frame.maxY - proxyFactor &&  touchStart.y < rect.frame.maxY + proxyFactor {
                resizeRect.bottomTouch = true
                print("bottom")
            }
            
            if touchStart.x > rect.frame.maxX - proxyFactor && touchStart.x < rect.frame.maxX + proxyFactor {
                resizeRect.rightTouch = true
                print("right")
            }
            
            if touchStart.x > rect.frame.minX - proxyFactor &&  touchStart.x < rect.frame.minX + proxyFactor {
                resizeRect.leftTouch = true
                print("left")
            }
            
            if touchStart.y > rect.frame.minY - proxyFactor &&  touchStart.y < rect.frame.minY + proxyFactor {
                resizeRect.topTouch = true
                print("top")
            }
            
        
    }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let currentTouchPoint = touch.location(in: self.view)
            let previousTouchPoint = touch.previousLocation(in: self.view)
            
            let deltaX = currentTouchPoint.x - previousTouchPoint.x
            let deltaY = currentTouchPoint.y - previousTouchPoint.y
//                print(currentTouchPoint.x,"currentPointx")
//                print(previousTouchPoint.x,"previousPointy")
//                print(deltaX,"X")
//                print(deltaY,"Y")
            if !resizeRect.isfullscreen{
                if resizeRect.middelTouch && leftConstraint.constant + deltaX > 0 &&  rightConstraint.constant - deltaX > 0 && topConstraint.constant + deltaY > 0 && bottomConstraint.constant - deltaY > 0 {
                    topConstraint.constant += deltaY
                    leftConstraint.constant += deltaX
                    rightConstraint.constant -= deltaX
                    bottomConstraint.constant -= deltaY
                }
                
                if rect.frame.maxX - rect.frame.minX >  344 {
                    print("inside")
                   
                    if resizeRect.leftTouch &&  leftConstraint.constant + deltaX > 0 {
                        leftConstraint.constant += deltaX
                    }
                    if resizeRect.rightTouch &&  rightConstraint.constant - deltaX > 0 {
                        rightConstraint.constant -= deltaX
                    }
                } else {
                    
                    if resizeRect.leftTouch && deltaX < 0 &&  leftConstraint.constant + deltaX > 0  {
                        print("outside")
                        leftConstraint.constant += deltaX
                    }
                    if resizeRect.rightTouch && deltaX > 0 &&  rightConstraint.constant - deltaX > 0 {
                        print("extoutside")
                        rightConstraint.constant -= deltaX
                    }
                }
                
                if rect.frame.maxY - rect.frame.minY >  184.5 {
                    if resizeRect.topTouch && topConstraint.constant + deltaY > 0 {
                        topConstraint.constant += deltaY
                    }
                  
                    if resizeRect.bottomTouch && bottomConstraint.constant - deltaY > 0 {
                        bottomConstraint.constant -= deltaY
                    }
                    
                } else {
                    if resizeRect.topTouch && deltaY < 0 && topConstraint.constant + deltaY > 0{
                        topConstraint.constant += deltaY
                    }
                  
                    if resizeRect.bottomTouch && deltaY > 0 && bottomConstraint.constant - deltaY > 0 {
                        bottomConstraint.constant -= deltaY
                    }
                }
            }
            
           
            
           
            
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (ended) in
                
            })
        }
    }
    
}



struct ResizeRect{
    var topTouch = false
    var leftTouch = false
    var rightTouch = false
    var bottomTouch = false
    var middelTouch = false
    var oldTopConst = 50.0
    var oldBottomConst = 50.0
    var oldLeftConst = 50.0
    var oldRightConst = 50.0
    var isfullscreen = false
    var fontSize = 12.0
    var notesData = ""
    var isMinimize = false
    var minmizeHeight = 0.0
    var minmizeWidth = 0.0
}
