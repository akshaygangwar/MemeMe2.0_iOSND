//
//  MemeTableViewController.swift
//  ImagePickerExperiment
//
//  Created by Akshay Gangwar on 06/04/16.
//  Copyright © 2016 Akshay Gangwar. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes:[Meme]!
    
    @IBAction func createMeme(sender: AnyObject) {
        let navigator = self.navigationController
        let newMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("CreateMemeViewController")
        navigator?.pushViewController(newMemeVC!, animated: true)
        //self.presentViewController(newMemeVC!, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = initialiseAppDelegate()
        memes = appDelegate.memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = initialiseAppDelegate()
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = memes[indexPath.item]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topString
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let meme = memes[indexPath.item]
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as!MemeDetailViewController
        detailVC.imageToPlace = meme.memedImage
        let navigator = self.navigationController
        navigator?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            handleDeletions(tableView, indexPath: indexPath)
        }
    }
    
    func handleDeletions(tableView: UITableView, indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let appDelegate = initialiseAppDelegate()
        appDelegate.memes.removeAtIndex(indexPath.row)
        memes = appDelegate.memes
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    
    func initialiseAppDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate
    }

}
