//
//  LevelModel.swift
//  Emoji
//
//  Created by Andrew Brown on 6/10/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import Foundation
import UIKit

class Level {
    let goal: NSString
    let movesToComplete : Int
    var completed: Bool
    var isCurrentLevel: Bool
    init(goal: NSString, movesToComplete: Int) {
        self.goal = goal
        self.movesToComplete = movesToComplete
        self.completed = false
        self.isCurrentLevel = false
    }
}

class LevelModel: NSObject {
    let levels : [Level] = [
        Level(goal: "🌱", movesToComplete: 5),
        Level(goal: "⚡️", movesToComplete: 3),
        Level(goal: "😐", movesToComplete: 2),
        Level(goal: "👤", movesToComplete: 2),
        Level(goal: "🌱", movesToComplete: 5),
        Level(goal: "⚡️", movesToComplete: 3),
        Level(goal: "😐", movesToComplete: 2),
        Level(goal: "👤", movesToComplete: 2),
    ]
    override init() {
        super.init()
        self.levels[0].isCurrentLevel = true
    }
    
}