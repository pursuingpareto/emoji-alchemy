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
        "😑": "indifference",
        "🐾": "animal",
        "👽": "alien",
        "💪": "strength",
        "🎨": "art",
        "🎲": "chance",
        "💦": "conservation",
        "☔️": "rain",
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
        "😌": "compassion",
        "😍": "in love",
        "☺️": "content",
        "😇": "innocence",
        "✌️": "peace",
        "😥": "sad",
        "👎": "bad",
        "🙈": "self-deception",
        "📉": "decrease",
        "💡": "thought",
        "🎅": "santa",
        "🏄": "surf",
        "☁️": "cloud",
        "⛄️": "snowman",
        "🌲": "tree",
        "🔵": "oxygen",
        "✊": "war",
        "🔊": "sound",
        "🔆": "light",
        "💬": "communication",
        "💭": "thought",
        "♨️": "heat",
        "💋": "lust",
        "⛽️": "fuel",
        "🐟": "fish",
        "🐝": "bee",
        "Ⓜ️": "mass",
        "🍎": "gravity",
        "⬛️": "darkness",
        "😛": "playful",
        "📡": "radio wave",
        "🐣": "rebirth",
        "🅿️": "pressure",
        "⚫️": "black hole",
        "✳️": "chaos",
        "🔢": "numbers",
        "🔤": "language",
        "🌾": "agriculture",
        "🏭": "industry",
        "💒": "marriage",
        "👀": "vision",
        "📜": "history",
        "❓": "uncertainty",
        "🔭": "observation"
    ]
    
    let normal_combos : [[NSString]] = [
        ["   ","🔥","💧","🌎","💨","🌀","☯" ,"⚡️","🌱","❤️","😐","👤","🔆","💭","♻️","⏳","♨️","💪","💋","😠","👨","⛽️","🐟","🐒","👩","🔋","🐾","💦","😎","🔊","🐝","😌","🍎","👽","😮","⭐️","Ⓜ️","💀","💭","⬛️","😛","📡"],
        
        ["🔥","   ","☯" ,"⚡️","❤️","🔆","💧","♨️","💪","💋","😠","👨","   ","🔧","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["💧","   ","  ","🌱","😐","💭","🔥","⛽️","🐟","  ","🐒","👩","🌈","🎨" ,"  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["🌎","   ","  ","  ","👤","♻️","💨","🔋","🐾","💦","😎","  ","   ","🔬","  ","  ","  ","⛄️","  ","  ","  ","   ","  ","  ","  ","   " ,"  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["💨","   ","  ","  ","   ","⏳","🌎","🔊","🐝","  ","😌","  ","   ","🔤","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["🌀","   ","  ","  ","   ","  ","⏳","🍎","👽","  ","😮","  ","⭐️","🔢","  ","🌌","  " ,"   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["☯" ,"   ","  ","  ","   ","  ","  ","Ⓜ️","💀","  ","💭","  ","⬛️","😐" ,"  ","🌀","  ","   ","  ","  ","  " ,"   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["⚡️","   ","  ","  ","   ","  ","  ","  ","   ","  ","😛","  ","📡","🏭","  ","❓","  ","   ","  ","  ","  " ,"   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["🌱","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","🌾","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["❤️","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","💒","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["😐","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["👤","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","💰","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["🔆","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","👀","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["💭","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["♻️","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
        ["⏳","   ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","📜","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","   ","  ","  ","  ","  ","  ", "  ","   ","  ","  ","  ", "  ","  ","  ","  ","   ","  "],
    ]
    
    let cycles = [
        ["🔥", "🌋", "🐣"],
        ["💧", "☁️", "☔️"],
        ["💨", "🅿️", "⚡️", "🏭"],
        ["🌎", "🌱", "💀"],
        ["🌀", "📈", "🌌", "📉", "⚫️"],
        ["☯",  "✳️"],
        ["❤️", "😑", "💬", "😌"]
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
        // TODO : Only get to man / woman through human
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
        ("💧", "🎶", "☔️"),
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
        ("😐", "👎", "😥"),
        ("❄️", "🔮", "🎅"),
        ("☯", "🌊", "🏄"),
        ("💧", "♻️", "☁️"),
        ("♻️", "☁️", "☔️"),
        ("☔️", "♻️", "💧"),
        ("⏳", "🌎", "🌋"),
        ("❄️", "🌱", "⛄️"),
        ("☀️", "🌱", "🌲"),
        ("☀️", "🌲", "🔵"),
        ("☀️", "☯", "🌑"),
        ("☯", "🌑", "☀️"),
        ("☯", "🌋", "🎨"),
        ("☯", "🎨", "🌋"),
        ("❤️", "🎶", "✌️"),
        ("☯", "✌️", "✊"),
        ("☯", "✊", "✌️"),
        ("⚡️", "💨", "🔊"),
        ("🎶", "🔊", "🎼"),
        // TODO : Ask for push notifications when communication discovered.
        ("🎶", "💨", "💬"),
        ("⚡️", "🌀", "🔆"),
    ]

    func makeComboDict() -> [NSString : NSString] {
        let first_row = self.normal_combos[0]
        var cDict : [NSString: NSString] = [:]
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        var e1 = ""
        for (i, row) in enumerate(self.normal_combos) {
            if (i == 0) {
                continue
            }
            e1 = row[0] as String
            for (j, res) in enumerate(row) {
                if (j == 0) {
                    continue
                }
                if res.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
                    var e2 = first_row[j]
                    var key1 = (e1 as String) + (e2 as String)
                    var key2 = (e2 as String) + (e1 as String)
                    cDict[key1] = res
                    cDict[key2] = res
                }
            }
        }
        return cDict
    }
    
//    func makeComboDict(combos : [(NSString, NSString, NSString)]) -> [NSString : NSString] {
//        println("MAKING COMBO DICT")
//        var cDict : [NSString: NSString] = [:]
//        for combo in combos {
//            var e1 = combo.0
//            var e2 = combo.1
//            var res = combo.2
//            var key1 = (e1 as String) + (e2 as String)
//            var key2 = (e2 as String) + (e1 as String)
//            cDict[key1] = res
//            cDict[key2] = res
//        }
//        return cDict
//    }
    
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
//        self.comboDict = makeComboDict(self.combinations)
        self.comboDict = makeComboDict()
        setAccessibleEmoji()
        print(self.accessibleEmoji)
    }

}
