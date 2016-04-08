//
//  MemeDetailViewController.swift
//  ImagePickerExperiment
//
//  Created by Akshay Gangwar on 07/04/16.
//  Copyright © 2016 Akshay Gangwar. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var imageHolder: UIImageView!
    
    var imageToPlace: UIImage?

    @IBAction func goBackButton(sender: AnyObject) {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageHolder.image = imageToPlace!
    }
    
}