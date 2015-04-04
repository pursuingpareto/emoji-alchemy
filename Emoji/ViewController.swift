//
//  ViewController.swift
//  Emoji
//
//  Created by Andy Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    let screen : CGRect  = UIScreen.mainScreen().bounds
    let primitiveEmojiNames = ["🔥","💧","🌎","💨","🌀"]
    var emojiSize = CGSize()
    var emojiPaddingFactor = CGFloat(0.1) // space to keep around primitives as fraction of emojiSize.width
    var primitiveContainerView : PrimitiveContainerView = PrimitiveContainerView(frame: CGRectZero)
    var cauldronView : CauldronView = CauldronView(frame:CGRectZero)
    let comboModel = CombinationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiSize = getEmojiSize()
        addPrimitivesToView()
        addCauldronToView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addPrimitiveContainer(location: CGPoint, size: CGSize) {
        let frame = CGRectMake(location.x, location.y, size.width, size.height)
        let primitiveContainer = PrimitiveContainerView(frame: frame)
        primitiveContainerView = primitiveContainer
        self.view.addSubview(primitiveContainer)
    }
    
    func addCauldronToView() {
        let diameter = screen.width / 2.0
        let x = screen.width/2 - diameter/2
        let y = screen.height/2 - emojiSize.height/2 - diameter/2
        let frame = CGRectMake(x, y, diameter, diameter)
        cauldronView = CauldronView(frame: frame)
        cauldronView.layer.cornerRadius = diameter / 5
        self.view.addSubview(cauldronView)
    }
    
    func getEmojiSize() -> CGSize {
        let screenWidth = screen.width
        let screenHeight = screen.height
        let numPrimitives = CGFloat(primitiveEmojiNames.count)
        let emojiWidth = screen.width / (numPrimitives * (1+emojiPaddingFactor) + emojiPaddingFactor)
        let emojiHeight = emojiWidth * 1.2
        let emojiSize = CGSize(width: emojiWidth, height: emojiHeight)
        return emojiSize
    }
    
    func addEmojiElement(emojiName: NSString, location: CGPoint) {
        var textName : NSString? = comboModel.emojiToText[emojiName]
        if textName == nil {
            textName = " "
        }
        let frame : CGRect = CGRectMake(location.x, location.y, emojiSize.width, emojiSize.height)
        var elementView = EmojiElement(frame: frame, emojiName : emojiName, textName : textName!)
        elementView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: "draggedEmoji:")
        elementView.addGestureRecognizer(panRec)
        self.view.addSubview(elementView)
    }
//    TODO : REFACTOR THIS SHIT
    func addEmojiElementToCauldron(emojiName: NSString, location: CGPoint) {
        var textName : NSString? = comboModel.emojiToText[emojiName]
        if textName == nil {
            textName = " "
        }
        let frame : CGRect = CGRectMake(location.x, location.y, emojiSize.width, emojiSize.height)
        var elementView = EmojiElement(frame: frame, emojiName : emojiName, textName : textName!)
        elementView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: "draggedEmoji:")
        elementView.addGestureRecognizer(panRec)
        cauldronView.addSubview(elementView)
        elementView.center = cauldronView.center
    }
    
    
    func convertCoords(previousView: UIView, nextView: UIView, point: CGPoint) -> CGPoint {
        let delta = CGVector(dx: previousView.frame.origin.x - nextView.frame.origin.x, dy: previousView.frame.origin.y - nextView.frame.origin.y)
        let newPoint = CGPoint(x: point.x + delta.dx, y: point.y + delta.dy)
        return newPoint
    }
    
    func addPrimitivesToView(){
        let y_location = screen.height - emojiSize.height - (emojiPaddingFactor * emojiSize.width)
        let container_y_location = y_location - emojiPaddingFactor * emojiSize.width
        let container_location = CGPoint(x: 0, y: container_y_location)
        let container_size = CGSizeMake(screen.width, screen.height-container_y_location)
        addPrimitiveContainer(container_location, size: container_size)
        for (i, e) in enumerate(primitiveEmojiNames) {
            var x_location = emojiPaddingFactor * emojiSize.width + CGFloat(i) * emojiSize.width * (1.0 + emojiPaddingFactor)
            addEmojiElement(e, location: CGPoint(x: x_location, y: y_location))
        }
    }
    
    func animateCombination(e1 : EmojiElement, e2 : EmojiElement) {
        var center = CGPoint(x: 0, y:0)
        center.x = (e1.center.x + e2.center.x) / 2.0
        center.y = (e1.center.y + e2.center.y) / 2.0
        UIView.animateWithDuration(0.3, animations: {
            e1.transform = CGAffineTransformMakeTranslation(center.x - e1.center.x, center.y - e1.center.y)
            e2.transform = CGAffineTransformMakeTranslation(center.x - e2.center.x, center.y - e2.center.y)
        })
        
    }

    func draggedEmoji(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            if CGRectContainsPoint(primitiveContainerView.frame, sender.view!.center) {
                println("Grabbed emoji from primitives")
                let copyLocation = CGPoint(x: sender.view!.frame.origin.x, y:sender.view!.frame.origin.y)
                let v = sender.view! as EmojiElement
                addEmojiElement(v.emojiName, location: copyLocation)
                // TODO : Make a copy
            } else if contains(cauldronView.subviews as [UIView], sender.view!) {

                println("Grabbed emoji from cauldron")
                // TODO : remove from cauldron view
                self.view.addSubview(sender.view!)
                sender.view!.frame.origin = convertCoords(cauldronView, nextView: self.view, point: sender.view!.frame.origin)
            } else {
                println("Grabbed emoji from canvas")
                // TODO :  Save start location
            }
            println("began")
            UIView.animateWithDuration(0.3, delay : 0.0, options : .CurveEaseOut, animations: {
                if let v = sender.view {
                    v.transform = CGAffineTransformMakeScale(1.3, 1.3)
                }
                
                }, completion: { finished in
                    println("grew") })

        case .Changed:
            self.view.bringSubviewToFront(sender.view!)
            var translation = sender.translationInView(self.view)
            sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
        case .Ended:
//            sender.view!.frame.size.height = sender.view!.frame.size.height / 1.5
//            sender.view!.frame.size.width = sender.view!.frame.size.width / 1.5
            if CGRectContainsRect(primitiveContainerView.frame, sender.view!.frame) {
                println("Attempting to drop in primitives")
                sender.view!.frame.origin.y = sender.view!.frame.origin.y - emojiSize.height * (1 + emojiPaddingFactor)
                
            } else if CGRectContainsRect(cauldronView.frame, sender.view!.frame) {
                UIView.animateWithDuration(0.5, delay : 0.0, options : .CurveEaseOut, animations: {
                    if let v = sender.view {
                        v.transform = CGAffineTransformMakeScale(1.0/1.3, 1.0/1.3)
                    }
                    
                    }, completion: { finished in
                        if self.cauldronView.subviews.count == 2 {
                            let svs = self.cauldronView.subviews as [EmojiElement]
                            self.animateCombination(svs[0], e2: svs[1])
//                            self.combineEmojis(svs[0], e2: svs[1])
                        } })
                
                println("Dropping in Cauldron")
                // TODO : add cauldron logic
                cauldronView.addSubview(sender.view!)
                sender.view!.frame.origin = convertCoords(self.view, nextView: cauldronView, point: sender.view!.frame.origin)
                // TODO : Return to start location if possible
                println(cauldronView.subviews.count)

            } else if !CGRectContainsPoint(self.view.frame, sender.view!.center) {
                println("Attempting to drag off screen")
                // TODO : add destroy logic
            } else {
                println("droping on canvas")
            }
            
        case .Possible:
            println("possible")
        case .Cancelled:
            println("cancelled")
        case .Failed:
            println("failed")
        }
        self.view.bringSubviewToFront(sender.view!)
        var translation = sender.translationInView(self.view)
        sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    func combineEmojis(e1: EmojiElement, e2: EmojiElement) {
        println("attempting to combine")
        let k = e1.emojiName + e2.emojiName

        if let newName = comboModel.comboDict[k] {
            for view in cauldronView.subviews  {
                var eView = view as UIView
                eView.removeFromSuperview()
                
            }
            let center = CGPoint(x: cauldronView.center.x - emojiSize.width/2, y: cauldronView.center.y - emojiSize.height/2)
            addEmojiElement(newName, location: center)
            println(comboModel.emojiToText[newName]!)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

