//
//  MemeCollectionViewController.swift
//  ImagePickerExperiment
//
//  Created by Akshay Gangwar on 07/04/16.
//  Copyright © 2016 Akshay Gangwar. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        
        let newMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("CreateMemeViewController")
        self.presentViewController(newMemeVC!, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension =  (self.view.frame.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.item]
        cell.collectionImageView?.image = meme.memedImage
        //cell.label?.text = "ABC"
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let meme = memes[indexPath.item]
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as!MemeDetailViewController
        detailVC.imageToPlace = meme.memedImage
        let navigator = self.navigationController
        navigator?.pushViewController(detailVC, animated: true)
    }
    
    func initialiseAppDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate
    }
    
}