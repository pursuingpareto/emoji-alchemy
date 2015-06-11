//
//  MapViewController.swift
//  Emoji
//
//  Created by Andrew Brown on 6/10/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit



class MapViewController: UICollectionViewController {
    let levelModel = LevelModel()
    var levelSelected : Level!
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        levelSelected = levelModel.levels[0]
        self.view.backgroundColor = UIColor.whiteColor()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        for l in levelModel.levels {
            println(l.completed)
        }
        let controller = segue.destinationViewController as! LevelViewController
        controller.delegate = self
        controller.level = levelSelected
    }
}

extension MapViewController: UICollectionViewDataSource {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.levelModel.levels.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mapCell", forIndexPath: indexPath) as! MapCollectionViewCell
        let level = self.levelModel.levels[indexPath.row]
        
        println(level.goal)
        cell.label.text = String(indexPath.row + 1)
        cell.layer.cornerRadius = cell.frame.width / 2.0
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.label.font = UIFont(name: cell.label.font.fontName, size: 20)
        if level.completed {
            cell.layer.borderColor = UIColor.greenColor().CGColor
            cell.label.textColor = UIColor.blackColor()
            cell.label.text = level.goal as String
        }
        else {
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.label.textColor = UIColor.lightGrayColor()
        }
        if level.isCurrentLevel {
            cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.label.textColor = UIColor.blackColor()
        }
        return cell
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension MapViewController: UICollectionViewDelegate {
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            println("selected cell")
            let level = levelModel.levels[indexPath.row]
            if level.isCurrentLevel || level.completed {
                levelSelected = level
                performSegueWithIdentifier("showLevel", sender: self)
            }
    }
}

extension MapViewController: LevelViewControllerDelegate {
    func levelViewControllerShouldResign(levelViewController: LevelViewController) {
        let level = levelViewController.level
        if level.completed && level.isCurrentLevel{
            levelModel.completeCurrentLevel()
        }
        self.collectionView?.reloadData()
        for l in levelModel.levels {
            println(l.completed)
        }
//        levelViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}