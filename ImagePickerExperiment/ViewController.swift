//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Akshay Gangwar on 29/03/16.
//  Copyright © 2016 Akshay Gangwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    @IBAction func createMeme(sender: AnyObject) {
        let generatedMeme = generateMemedImage()
        save(generatedMeme)
        let activityController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func viewSentMemes(sender: AnyObject) {
        let sentMemesVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesViewController")
        self.presentViewController(sentMemesVC!, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, image: imagePicker.image!, memedImage: memedImage)
        let appDelegate = initialiseAppDelegate()
        appDelegate.memes.append(meme)
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //perform initial app setup
        doInitialSetup()
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    //dismiss keyboard when the user taps outside the text box, for a better UX than having to press Return.
    func tap(gesture: UITapGestureRecognizer) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        pickImageFromAnySource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickImageFromAnySource(UIImagePickerControllerSourceType.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePicker.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        shareMeme.enabled = true
    }
    
    func pickImageFromAnySource(sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //if cancelled by user, simply dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
        //v2.0 , if cancelled nav back to Sent Memes.
        let navigator = self.navigationController
        navigator?.popToRootViewControllerAnimated(true)
        //let sentMemesVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesViewController")
        //self.presentViewController(sentMemesVC!, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Initial App Setup Functions
    
    func initialiseTextFields(textFields: [UITextField]) {
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self
            textField.textAlignment = NSTextAlignment.Center
            textField.adjustsFontSizeToFitWidth = true
        }
    }
    
    func assignShareButtonState() {
        if (imagePicker.image == nil) {
            shareMeme.enabled = false
        }
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func doInitialSetup() {
        initialiseTextFields([topTextField, bottomTextField])
        assignShareButtonState()
        setTapGesture()
    }
    
    func initialiseAppDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate
    }

}

