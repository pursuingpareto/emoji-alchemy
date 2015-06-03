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
    let comboModel = CombinationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiSize = getEmojiSize()
        addPrimitivesToView()

    }
    
    func addPrimitiveContainer(location: CGPoint, size: CGSize) {
        let frame = CGRectMake(location.x, location.y, size.width, size.height)
        let primitiveContainer = PrimitiveContainerView(frame: frame)
        primitiveContainerView = primitiveContainer
        self.view.addSubview(primitiveContainer)
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
    
    func addEmojiCentered(emojiName: NSString, location: CGPoint)->EmojiElement {
        let origin = CGPointMake(location.x - emojiSize.width/2, location.y - emojiSize.height / 2)
        return addEmojiElement(emojiName, location: origin)
    }
    
    func addEmojiElement(emojiName: NSString, location: CGPoint) ->EmojiElement {
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
        return elementView
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
        self.view.addSubview(elementView)
        elementView.center = self.view.center
    }
    
    func convertCoords(previousView: UIView, nextView: UIView, point: CGPoint) -> CGPoint {
        println("PREV ORIGIN: \(previousView.frame.origin.x), \(previousView.frame.origin.y)")
        println("NEXT ORIGIN: \(nextView.frame.origin.x), \(nextView.frame.origin.y)")
        let delta = CGVector(dx: previousView.frame.origin.x - nextView.frame.origin.x, dy: previousView.frame.origin.y - nextView.frame.origin.y)
        let newPoint = CGPoint(x: point.x + delta.dx, y: point.y + delta.dy)
        return newPoint
    }
    
    func addPrimitivesToView(){
        let y_location = screen.height - emojiSize.height - (emojiPaddingFactor * 2 * emojiSize.height)
        let container_y_location = y_location - emojiPaddingFactor * 2*emojiSize.height
        let container_location = CGPoint(x: 0, y: container_y_location)
        let container_size = CGSizeMake(screen.width, screen.height-container_y_location)
        addPrimitiveContainer(container_location, size: container_size)
        for (i, e) in enumerate(primitiveEmojiNames) {
            var x_location = emojiPaddingFactor * emojiSize.width + CGFloat(i) * emojiSize.width * (1.0 + emojiPaddingFactor)
            addEmojiElement(e, location: CGPoint(x: x_location, y: y_location))
        }
    }
    
    func animateNewEmoji(e: EmojiElement, combinationLabel : UILabel) {
        
        combinationLabel.font = UIFont(name: combinationLabel.font.fontName, size: 30)
        combinationLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        combinationLabel.alpha = 0
        self.view.addSubview(combinationLabel)
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: {
            combinationLabel.alpha = 1.0
            e.transform = CGAffineTransformMakeScale(1.3, 1.3)
            e.center = CGPointMake(e.center.x, e.center.y-self.view.frame.height)
            }, completion : {finished in
                
                
        })
        UIView.animateWithDuration(2.5, delay: 2.0, options: .CurveEaseInOut, animations: {
            combinationLabel.alpha = 1
            }, completion: {finished in
                
        })
        UIView.animateWithDuration(1.0, delay: 3.5, options: .CurveEaseIn, animations: {
            combinationLabel.alpha = 0
            }, completion: {finished in
        })
    }
    
    func animateCombination(e1 : EmojiElement, e2 : EmojiElement, res : NSString) {
        
        var combinationLabel = UILabel()
        combinationLabel.text = (e1.emojiName as String) + " + " + (e2.emojiName as String) + " = " + (res as String)
        combinationLabel.textAlignment = NSTextAlignment.Center
        combinationLabel.frame = CGRectMake(0, 20, screen.width, emojiSize.height)
        
        let center = convertCoords(self.view, nextView: self.view, point: self.view.center)
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
            e1.center = center
            e2.center = center
            }, completion : { finished in
                e1.removeFromSuperview()
                e2.removeFromSuperview()
                let x = self.view.frame.origin.x + self.view.frame.width/2
                let y = self.view.frame.origin.y + self.view.frame.height/2
                let loc = CGPointMake(x, y)
                let eNew = self.addEmojiCentered(res, location: loc)
                self.animateNewEmoji(eNew, combinationLabel: combinationLabel)
                
        })
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func expelEmoji(emoji : EmojiElement) {
        println("EXPELLING EMOJI")
        UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseIn, animations: {
            var tx = CGFloat(arc4random_uniform(UInt32(self.emojiSize.width)))
            var ty = self.view.frame.height + CGFloat(arc4random_uniform(UInt32(self.emojiSize.height)))
            println("Translating tx: \(tx) ty: \(ty)")
            emoji.center = CGPointMake(emoji.center.x - tx, emoji.center.y - ty)
            
            }, completion : { finished in
                var oldView = emoji.superview!
                emoji.removeFromSuperview()
                
                self.view.addSubview(emoji)
                println("oldView was \(oldView)")
                println("emoji center is at x: \(emoji.center.x) y: \(emoji.center.y)")

                emoji.center = self.convertCoords(oldView, nextView: self.view, point: emoji.center)
                
                println("after center is at x: \(emoji.center.x) y: \(emoji.center.y)")
                emoji.frame.origin = emoji.layer.frame.origin
            })
    
        
    }

    func draggedEmoji(sender: UIPanGestureRecognizer) {
        var selected : EmojiElement
        if let selected = sender.view as? EmojiElement {
            switch sender.state {
            case .Began:
                if CGRectContainsPoint(primitiveContainerView.frame, selected.center) {
                    println("Grabbed emoji from primitives")
                    let copyLocation = CGPoint(x: selected.frame.origin.x, y:selected.frame.origin.y)
                    addEmojiElement(selected.emojiName, location: copyLocation)
                } else if contains(self.view.subviews as! [UIView], selected) {
                    
                    println("Grabbed emoji from cauldron")
                    // TODO : remove from cauldron view
                    self.view.addSubview(selected)
                    selected.frame.origin = convertCoords(self.view, nextView: self.view, point: selected.frame.origin)
                } else {
                    println("Grabbed emoji from canvas")
                    // TODO :  Save start location
                }
                println("began")
                UIView.animateWithDuration(0.3, delay : 0.0, options : .CurveEaseOut, animations: {
                    selected.transform = CGAffineTransformMakeScale(1.3, 1.3)
                    
                    }, completion: { finished in
                        println("grew") })

            case .Changed:
                self.view.bringSubviewToFront(selected)
                var translation = sender.translationInView(self.view)
                selected.center = CGPointMake(selected.center.x + translation.x, selected.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: self.view)
            
            case .Ended:
                if CGRectContainsPoint(primitiveContainerView.frame, selected.center) {
                    println("Attempting to drop in primitives")
                    UIView.animateWithDuration(0.3, delay : 0.0, options : .CurveEaseInOut, animations: {
                        let dy = -self.emojiSize.height * (1 + 4*self.emojiPaddingFactor)
//                        selected.transform = CGAffineTransformMakeTranslation(0, dy )
                        selected.center = CGPointMake(selected.center.x, selected.center.y + dy)
                        }, completion: { finished in
                            println("grew") })
//                    selected.frame.origin.y = -self.emojiSize.height * (1 + self.emojiPaddingFactor)
                    
                } else if CGRectContainsPoint(self.view.frame, selected.center) {
                    self.view.addSubview(selected)
                    selected.frame.origin = convertCoords(self.view, nextView: self.view, point: selected.frame.origin)
                    if self.view.subviews.count == 2 {
                        let svs = self.view.subviews as! [EmojiElement]
                        var e1 = svs[0]
                        var e2 = svs[1]
                        if let res = self.combineEmojis(e1, e2: e2)  {
                            animateCombination(e1, e2: e2, res: res)
                        } else {
                            expelEmoji(selected)
                        }
                    
                    } else {
                        UIView.animateWithDuration(0.5, delay : 0.0, options : .CurveEaseOut, animations: {
                            selected.transform = CGAffineTransformMakeScale(1.0/1.3, 1.0/1.3)
                            }, completion: { finished in
                                })
                        println("Dropping in Cauldron")
                        // TODO : add cauldron logic
                        }

                } else if !CGRectContainsPoint(self.view.frame, selected.center) {
                    println("Attempting to drag off screen")
                    selected.removeFromSuperview()
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
            self.view.bringSubviewToFront(selected)
            var translation = sender.translationInView(self.view)
            selected.center = CGPointMake(selected.center.x + translation.x, selected.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
        }
    }
    
    func combineEmojis(e1: EmojiElement, e2: EmojiElement) -> NSString? {
        println("attempting to combine")
        let k = (e1.emojiName as String) + (e2.emojiName as String)

        if let newName = comboModel.comboDict[k] {
            println(comboModel.emojiToText[newName]!)
            return newName
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

