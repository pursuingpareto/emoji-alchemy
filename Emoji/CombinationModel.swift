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
    
    init() {
        self.comboDict = makeComboDict(self.combinations)
    }

}
