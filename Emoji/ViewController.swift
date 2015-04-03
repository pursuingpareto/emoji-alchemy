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
    var primitiveContainerView : PrimitiveContainerView? = nil
    var cauldronView : CauldronView? = nil
    
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
        cauldronView!.layer.cornerRadius = diameter / 2
        self.view.addSubview(cauldronView!)
    }
    
    func getEmojiSize() -> CGSize {
        let screenWidth = screen.width
        let screenHeight = screen.height
        let numPrimitives = CGFloat(primitiveEmojiNames.count)
        let emojiWidth = screen.width / (numPrimitives * (1+emojiPaddingFactor) + emojiPaddingFactor)
        let emojiHeight = emojiWidth * 1.3
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
            if CGRectContainsRect(primitiveContainerView!.frame, sender.view!.frame) {
                println("That's Fundamental!")
                // TODO : Make a copy
            }
            else {
                println("Not Fundamental")
                // Save start location
            }
            println("began")
        case .Changed:
            self.view.bringSubviewToFront(sender.view!)
            var translation = sender.translationInView(self.view)
            sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
        case .Ended:
            if CGRectContainsRect(primitiveContainerView!.frame, sender.view!.frame) {
                println("That's Fundamental!")
                // TODO : Return to start location if possible
            }
            println("ended")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

