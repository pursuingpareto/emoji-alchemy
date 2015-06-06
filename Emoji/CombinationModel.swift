//
//  CombinationModel.swift
//  Emoji
//
//  Created by Andrew Brown on 4/3/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import Foundation
import UIKit

class CombinationModel {
    
    var comboDict : [NSString : NSString] = [:]
    
    var accessibleEmoji : Set<NSString> = Set<NSString>()
    
    // NOTE(ih) tried to maked isAccessible a closure in setAccessbileEmoji, but had problems making closure recursive
    var visitedCombo : Set<NSString> = Set<NSString>()
    
    let fundamentalEmoji = ["🔥", "💧", "💨", "🌎", "🌀"]
    
    let emojiToText : [NSString: NSString] = [
        "🔥": "fire",
        "💧": "water",
        "💨": "air",
        "🌎": "earth",
        "🌀": "space",
        "⏳": "time",
        "⚡️": "energy",
        "🌋": "destruction",
        "☀️": "sun",
        "❄️": "snow",
        "🌱": "life",
        "❤️": "love",
        "🎶": "harmony",
        "☯": "balance",
        "🌑": "moon",
        "👤": "human",
        "🔋": "electricity",
        "👨": "man",
        "💣": "bomb",
        "🌊": "wave",
        "🌈": "rainbow",
        "🌅": "sunrise",
        "⭐️": "star",
        "👩": "woman",
        "😐": "emotion",
        "🐾": "animal",
        "👽": "alien",
        "💪": "strength",
        "🎨": "creativity",
        "🎲": "chance",
        "💦": "rain",
        "🎼": "music",
        "♻️": "cycle",
        "🌌": "universe",
        "🔃": "rotation",
        "🚀": "exploration",
        "👥": "people",
        "🔼": "change",
        "📈": "increase",
        "💀": "death",
        "🔧": "tool",
        "🔪": "weapon",
        "🔬": "science",
        "🔮": "belief",
        "👍": "good",
        "😀": "happiness",
        "😠": "anger",
        "😎": "confidence",
        "😮": "awe",
        "🐒": "curiosity",
        "😌": "calmness",
        "😍": "in love",
        "☺️": "content",
        "😇": "peace",
        "😥": "sad",
        "👎": "bad",
        "🙈": "self-deception",
        "📉": "decrease",
        "💡": "thought",

    ]

    let combinations : [(NSString, NSString, NSString)] = [
        ("🌀", "🌎", "⏳"),
        ("🔥", "💧", "☯"),
        ("🔥", "💨", "⚡️"),
        ("🔥", "🌎", "🌋"),
        ("🔥", "🌀", "☀️"),
        ("💧", "💨", "❄️"),
        ("💧", "🌎", "🌱"),
        ("💧", "🌀", "🌑"),
        ("💨", "🌎", "❤️"),
        ("💨", "🌀", "🎶"),
        //        ("🌎", "⏳"),
        ("🌀", "⏳", "🌌"),
        ("🔥", "⚡️", "💣"),
        ("💧", "⚡️", "🌊"),
        ("🌎", "⚡️", "🔋"),
        ("💧", "🌋", "🌊"),
        ("💧", "☀️", "🌈"),
        ("🌎", "☀️", "🌅"),
        ("🌀", "☀️", "⭐️"),
        ("🔥", "❄️", "💧"),
        //        ("🌎", "❄️"),
        ("🔥", "🌱", "👨"),
        ("💧", "🌱", "👩"),
        ("💨", "🌱", "😐"),
        ("🌎", "🌱", "👤"),
        ("🌀", "🌱", "👽"),
        ("🔥", "❤️", "💪"),
        ("💧", "❤️", "🎨"),
        ("💨", "❤️", "🎲"),
        ("🌎", "❤️", "👍"),
        ("🌀", "❤️", "🔮"),
        ("💧", "🎶", "💦"),
        ("💨", "🎶", "🎼"),
        ("🌎", "🎶", "♻️"),
        ("🌀", "🎶", "🌌"),
        ("🔥", "☯", "💧"),
        ("💧", "☯", "🔥"),
        ("💨", "☯", "🌎"),
        ("🌎", "☯", "💨"),
        ("🌀", "☯", "⏳"),
        ("🌎", "🌑", "🔃"),
        ("🌀", "🌑", "🚀"),
        ("🌱", "❤️", "😀"),
        ("🌋", "❤️", "☯"),
        ("👤", "👤", "👥"),
        ("🌱", "⏳", "📈"),
        ("🌱", "🌋", "💀"),
        ("👤", "🌎", "🔧"),
        ("👤", "🔥", "🔪"),
        ("👤", "🌀", "🚀"),
        ("👤", "💧", "🔬"),
        ("👤", "💨", "🔮"),
        ("👤", "❤️", "👍"),
        ("👤", "⏳", "💀"),
        ("😐", "👍", "😀"),
        ("😐", "🔥", "😠"),
        ("😐", "🌎", "😎"),
        ("😐", "🌀", "😮"),
        ("😐", "💧", "🐒"),
        ("😐", "💨", "😌"),
        ("😐", "⏳", "❤️"),
        ("😐", "❤️", "😍"),
        ("😐", "☯", "☺️"),
        ("😐", "🎶", "😇"),
        ("😐", "👎", "😥")
    ]

    func makeComboDict(combos : [(NSString, NSString, NSString)]) -> [NSString : NSString] {
        println("MAKING COMBO DICT")
        var cDict : [NSString: NSString] = [:]
        for combo in combos {
            var e1 = combo.0
            var e2 = combo.1
            var res = combo.2
            var key1 = (e1 as String) + (e2 as String)
            var key2 = (e2 as String) + (e1 as String)
            cDict[key1] = res
            cDict[key2] = res
        }
        return cDict
    }
    
    func isAccessible (emoji: NSString) -> Bool {
        if self.accessibleEmoji.contains(emoji) {
            return true
        } else {
            for (componentEmoji1, componentEmoji2, targetEmoji) in self.combinations {
                if (targetEmoji == emoji) {
                    let combo = (componentEmoji1 as String) + (componentEmoji2 as String)
                    if self.visitedCombo.contains(combo) {
                        continue
                    }
                    self.visitedCombo.insert(combo)
                    return isAccessible(componentEmoji1) && isAccessible(componentEmoji2)
                }
            }
            return false
        }
    }

    
    func setAccessibleEmoji() -> Set<NSString> {
        // initialize with the fundamental emoji
        for emoji in self.fundamentalEmoji {
            self.accessibleEmoji.insert(emoji)
        }
        
        for (componentEmoji1, componentEmoji2, targetEmoji) in self.combinations {
            if (self.accessibleEmoji.contains(targetEmoji)) {
                continue
            }
            if (isAccessible(componentEmoji1) && isAccessible(componentEmoji2)) {
                self.accessibleEmoji.insert(targetEmoji)
            }
        }

        return accessibleEmoji
    }
    
    
    init() {
        self.comboDict = makeComboDict(self.combinations)
        setAccessibleEmoji()
    }

}
