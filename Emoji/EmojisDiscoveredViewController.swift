//
//  EmojisDiscoveredViewController.swift
//  Emoji
//
//  Created by Andrew Brown on 6/4/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

class EmojisDiscoveredViewController: UICollectionViewController {
    let cm = CombinationModel()
    private let reuseIdentifier = "emojiCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var discovered = [NSString]()
    var discoveredEmojis = [EmojiElement]()
}

extension EmojisDiscoveredViewController : UICollectionViewDataSource {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discovered.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EmojiCell
        cell.backgroundColor = UIColor.clearColor()
        //        cell.emojiName.text = discovered[indexPath.row] as String
        let e = discoveredEmojis[indexPath.row] as EmojiElement
        cell.addSubview(e)
        return cell
    }
    
}