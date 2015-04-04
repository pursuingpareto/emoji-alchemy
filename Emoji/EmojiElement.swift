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
    init(frame: CGRect, emojiName: NSString) {
        self.emojiName = emojiName
        var labelFrame = CGRectMake(0, 0, frame.width, frame.height)
        self.label = UILabel(frame: labelFrame)
        self.label.text = emojiName
        self.label.textAlignment = NSTextAlignment.Center
        super.init(frame: frame)
        self.layer.cornerRadius = 0.1 * self.frame.width
        self.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}