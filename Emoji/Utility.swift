//
//  utility.swift
//  Emoji
//
//  Created by Irvin Hwang on 6/4/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import Foundation

// http://stackoverflow.com/a/24059196
func randRange (lower: Int , upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
}

// http://stackoverflow.com/a/27700638
func randomSelect<T>(array: [T]) -> T {
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    return array[randomIndex]
}