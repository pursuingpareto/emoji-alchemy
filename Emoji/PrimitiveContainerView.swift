//
//  PrimitiveContainerView.swift
//  Emoji
//
//  Created by Andy Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import Foundation
import UIKit

class PrimitiveContainerView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0.9, alpha: 0.3)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
