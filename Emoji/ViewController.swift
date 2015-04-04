//
//  ViewController.swift
//  Emoji
//
//  Created by Andy Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let screen : CGRect  = UIScreen.mainScreen().bounds
    let primitiveEmojiNames = ["🔥","💧","🌎","💨","🌀"]
    var emojiSize = CGSize()
    var emojiPaddingFactor = CGFloat(0.25) // space to keep around primitives as fraction of emojiSize.width
    var primitiveContainerView : PrimitiveContainerView = PrimitiveContainerView(frame: CGRectZero)
    var cauldronView : CauldronView = CauldronView(frame:CGRectZero)
    
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
        let diameter = screen.width / 3.0
        let x = screen.width/2 - diameter/2
        let y = screen.height/2 - emojiSize.height/2 - diameter/2
        let frame = CGRectMake(x, y, diameter, diameter)
        cauldronView = CauldronView(frame: frame)
        cauldronView.layer.cornerRadius = diameter / 2
        self.view.addSubview(cauldronView)
    }
    
    func getEmojiSize() -> CGSize {
        let screenWidth = screen.width
        let screenHeight = screen.height
        let numPrimitives = CGFloat(primitiveEmojiNames.count)
        let emojiWidth = screen.width / (numPrimitives * (1+emojiPaddingFactor) + emojiPaddingFactor)
        let emojiHeight = emojiWidth * 1.0
        let emojiSize = CGSize(width: emojiWidth, height: emojiHeight)
        return emojiSize
    }
    
    func addEmojiElement(emojiName: NSString, location: CGPoint) {
        let frame : CGRect = CGRectMake(location.x, location.y, emojiSize.width, emojiSize.height)
        var elementView = EmojiElement(frame: frame, emojiName : emojiName)
        elementView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: "draggedEmoji:")
        elementView.addGestureRecognizer(panRec)
        self.view.addSubview(elementView)
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

    func draggedEmoji(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            if CGRectContainsRect(primitiveContainerView.frame, sender.view!.frame) {
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
        case .Changed:
            self.view.bringSubviewToFront(sender.view!)
            var translation = sender.translationInView(self.view)
            sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
        case .Ended:

            if CGRectContainsRect(primitiveContainerView.frame, sender.view!.frame) {
                println("Attempting to drop in primitives")
                sender.view!.frame.origin.y = sender.view!.frame.origin.y - emojiSize.height * (1 + emojiPaddingFactor)
                
            } else if CGRectContainsRect(cauldronView.frame, sender.view!.frame) {
                println("Dropping in Cauldron")
                // TODO : add cauldron logic
                cauldronView.addSubview(sender.view!)
                sender.view!.frame.origin = convertCoords(self.view, nextView: cauldronView, point: sender.view!.frame.origin)
                // TODO : Return to start location if possible
                println(cauldronView.subviews.count)
                
                if cauldronView.subviews.count == 2 {
                    combineEmojis(cauldronView.subviews as [EmojiElement])
                }
                
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
    
    func combineEmojis([EmojiElement]) {
        println("attempting to combine")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

