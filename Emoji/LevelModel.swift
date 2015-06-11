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
    func completeCurrentLevel() -> Bool {
        for (i, level) in enumerate(levels) {
            if level.isCurrentLevel {
                level.completed = true
                level.isCurrentLevel = false
                if (i < levels.count) {
                    levels[i + 1].isCurrentLevel = true
                }
                println("LEVEL IS...")
                println(level)
                return true
            }
        }
        return false
    }
}