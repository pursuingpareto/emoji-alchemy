//
//  EmojiElement.swift
//  Emoji
//
//  Created by Andy Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import Foundation
import UIKit

class EmojiElement : UIView {
    let emojiName : NSString
    let label : UILabel
    let textLabel : UILabel
    init(frame: CGRect, emojiName: NSString, textName : NSString) {
        self.emojiName = emojiName
        var labelFrame = CGRectMake(0, -10, frame.width, frame.height)
        self.label = UILabel(frame: labelFrame)
        self.label.text = emojiName as String
        self.label.textAlignment = NSTextAlignment.Center
        var textLabelFrame = CGRectMake(-0.25 * frame.width, frame.height/2, 1.5 * frame.width, frame.height / 2)
        self.textLabel = UILabel(frame: textLabelFrame)
        self.textLabel.text = textName as String
        self.textLabel.textAlignment = NSTextAlignment.Center
        
        super.init(frame: frame)
        self.layer.cornerRadius = 0.2 * self.frame.width
        self.addSubview(label)
        self.addSubview(textLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}