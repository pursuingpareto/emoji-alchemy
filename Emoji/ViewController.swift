//
//  ViewController.swift
//  Emoji
//
//  Created by Andy Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let screen : CGRect  = UIScreen.mainScreen().bounds
    let primitiveEmojiNames = ["🔥","💧","🌎","💨","🌀"]
    var emojiSize = CGSize()
    var emojiPaddingFactor = CGFloat(0.1) // space to keep around primitives as fraction of emojiSize.width
    var primitiveContainerView : PrimitiveContainerView = PrimitiveContainerView(frame: CGRectZero)
    let comboModel = CombinationModel()
    let growFactor = 2.0
    var activeEmojis : [EmojiElement : [NSString]] = Dictionary<EmojiElement, [NSString]>()
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
    
    func addPrimitivesToView(){
        let y_location = screen.height - emojiSize.height - (emojiPaddingFactor * 2 * emojiSize.height)
        let container_y_location = y_location - emojiPaddingFactor * 2*emojiSize.height
        let container_location = CGPoint(x: 0, y: container_y_location)
        let container_size = CGSizeMake(screen.width, screen.height-container_y_location)
        addPrimitiveContainer(container_location, size: container_size)
        for (i, e) in enumerate(primitiveEmojiNames) {
            var x_location = emojiPaddingFactor * emojiSize.width + CGFloat(i) * emojiSize.width * (1.0 + emojiPaddingFactor)
            let newEmoji = createEmojiElement(e)
            newEmoji.frame.origin = CGPointMake(x_location, y_location)
            self.view.addSubview(newEmoji)
        }
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
    
    func createEmojiElement(emojiName: NSString) -> EmojiElement {
        var textName : NSString? = comboModel.emojiToText[emojiName]
        if textName == nil {
            textName = " "
        }
        let frame : CGRect = CGRectMake(0, 0, emojiSize.width, emojiSize.height)
        var elementView = EmojiElement(frame: frame, emojiName : emojiName, textName : textName!)
        elementView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: "draggedEmoji:")
        let pinchRec = UIPinchGestureRecognizer()
        pinchRec.addTarget(self, action: "pinchedEmoji:")
        elementView.addGestureRecognizer(panRec)
        elementView.addGestureRecognizer(pinchRec)
        return elementView
    }
    
    func animateNewEmoji(e: EmojiElement, combinationLabel : UILabel) {
        
        combinationLabel.font = UIFont(name: combinationLabel.font.fontName, size: 30)
        combinationLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        combinationLabel.alpha = 0
        self.view.addSubview(combinationLabel)
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: {
            combinationLabel.alpha = 1.0
//            e.transform = CGAffineTransformMakeScale(1.3, 1.3)
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
    
    func animateCombination(e1 : EmojiElement, e2 : EmojiElement, res : EmojiElement) {
        var combinationLabel = UILabel()
        combinationLabel.text = (e1.emojiName as String) + " + " + (e2.emojiName as String) + " = " + (res.emojiName as String)
        combinationLabel.textAlignment = NSTextAlignment.Center
        combinationLabel.frame = CGRectMake(0, 20, screen.width, emojiSize.height)
        let cx = (e1.center.x + e2.center.x) / 2
        let cy = (e1.center.y + e2.center.y) / 2
        let center = CGPointMake(cx, cy)
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
            e1.center = center
            e2.center = center
            res.center = center
            self.view.addSubview(combinationLabel)
            }, completion : { finished in
                e1.removeFromSuperview()
                e2.removeFromSuperview()
                self.view.addSubview(res)
                combinationLabel.removeFromSuperview()
        })
    }
    
    func animateRejection(e1: EmojiElement, e2: EmojiElement) {
        // andy's algorithm
        let movementMagnitude = e1.frame.width/2
        let dX = e2.center.x - e1.center.x
        let dY = e2.center.y - e1.center.y
        let h = sqrt(pow(dX, 2)+pow(dY, 2))
        let xAmount = dX/h * movementMagnitude
        let yAmount = dY/h * movementMagnitude
        let newE1Center = CGPointMake(e1.center.x - xAmount, e1.center.y - yAmount)
        let newE2Center = CGPointMake(e2.center.x + xAmount, e2.center.y + yAmount)

        UIView.animateWithDuration(0.3, animations: {
            e1.center = newE1Center
            e2.center = newE2Center
        })
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }

    func draggedEmoji(sender: UIPanGestureRecognizer) {
        var selected : EmojiElement
        if let selected = sender.view as? EmojiElement {
            switch sender.state {
            case .Began:
                if CGRectContainsPoint(primitiveContainerView.frame, selected.center) {
                    let copyEmoji = createEmojiElement(selected.emojiName)
                    let copyLocation = CGPoint(x: selected.frame.origin.x, y:selected.frame.origin.y)
                    copyEmoji.frame.origin = copyLocation
                    self.view.addSubview(copyEmoji)
                    UIView.animateWithDuration(0.3, delay : 0.0, options : .CurveEaseOut, animations: {
                        selected.transform = CGAffineTransformMakeScale(2.0, 2.0)
                        
                        }, completion: { finished in
                            println("grew") })
                }

                
            case .Changed:
                self.view.bringSubviewToFront(selected)
                var translation = sender.translationInView(self.view)
                selected.center = CGPointMake(selected.center.x + translation.x, selected.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: self.view)
            
            case .Ended:
                // if the emoji ends up in the bottom bar move it above the bar
                if CGRectContainsPoint(primitiveContainerView.frame, selected.center) {

                    UIView.animateWithDuration(0.3, delay : 0.0, options : .CurveEaseInOut, animations: {
                        let dy = -self.emojiSize.height * (1 + 4*self.emojiPaddingFactor)

                        selected.center = CGPointMake(selected.center.x, selected.center.y + dy)
                        }, completion: { finished in
                            println("grew") })

                // remove emojis dragged off the screen
                }
                else if !CGRectContainsPoint(self.view.frame, selected.center) {
                    println("Attempting to drag off screen")
                    activeEmojis.removeValueForKey(selected)
                    selected.removeFromSuperview()
                }
                //    emoji dragged onto canvas
                else {
                    var combined = false
                    let otherEmoji = activeEmojis.keys.array.filter({$0 != selected})
                    for activeEmoji in otherEmoji {
                        if CGRectContainsPoint(activeEmoji.frame, selected.center) {
                            // if the emoji match create the combination
                            if let res = combineEmojis(selected, e2: activeEmoji)  {
                                activeEmojis[res] = [activeEmoji.emojiName, selected.emojiName]
                                activeEmojis.removeValueForKey(activeEmoji)
                                activeEmojis.removeValueForKey(selected)
                                animateCombination(selected, e2: activeEmoji, res: res)
                                

                                combined = true
                                break
                            }
                            // if the emoji don't match display to the user
                            else {
                                println("Emoji didn't match")
                                animateRejection(activeEmoji, e2: selected)
                            }
                        }
                    }
                    if !combined {
                        if activeEmojis[selected] == nil{
                            self.activeEmojis[selected] = [NSString()]
                        }
                        
                    }
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
    
    func pinchedEmoji(sender: UIPinchGestureRecognizer) {
        println("PINCHED")
        if let view = sender.view as? EmojiElement {
            println("ACTIVE VIEWS ARE:")
            for e in activeEmojis.keys {
                println(e.emojiName)
            }
            println("ACTIVE ANCESTORS ARE")
            for a in activeEmojis.values {
                println(a)
            }
            for activeView in activeEmojis.keys {
                if activeView == view {
                    let ancestors = activeEmojis[activeView]
                    if ancestors!.count == 2 {
                        var e1 = createEmojiElement(ancestors![0])
                        var e2 = createEmojiElement(ancestors![1])
                        activeEmojis[e1] = [""]
                        activeEmojis[e2] = [""]
                        activeEmojis.removeValueForKey(activeView)
                        e1.center = activeView.center
                        e1.center.x = activeView.center.x - activeView.frame.width / 2
                        e2.center = activeView.center
                        e2.center.x = activeView.center.x + activeView.frame.width / 2
                        e1.transform = CGAffineTransformMakeScale(2.0, 2.0)
                        e2.transform = CGAffineTransformMakeScale(2.0, 2.0)
                        self.view.addSubview(e1)
                        self.view.addSubview(e2)
                        activeView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func combineEmojis(e1: EmojiElement, e2: EmojiElement) -> EmojiElement? {
        let k = (e1.emojiName as String) + (e2.emojiName as String)
        if let newName = comboModel.comboDict[k] {
            let newEmoji = createEmojiElement(newName)
            newEmoji.transform = CGAffineTransformMakeScale(2.0, 2.0)
//            newEmoji.frame.size = e1.frame.size
            return newEmoji
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }


}

