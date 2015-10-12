//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/3/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    let MAX_CHARS = 140
    
    @IBOutlet weak var remainingCharsLabel: UILabel!
    @IBOutlet weak var composeScrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweetTextView.delegate = self
        self.profileImageView.setImageWithURL(User.currentUser?.profileImageUrl)
        self.profileImageView.layer.cornerRadius = 9.0
        self.profileImageView.layer.masksToBounds = true
        self.nameLabel.text = User.currentUser?.name
        self.screenNameLabel.text = "@\(User.currentUser!.screenname)"
        
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
        self.remainingCharsLabel.text = "\(MAX_CHARS)"
        
        self.tweetTextView.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        self.adjustScrollViewContentSize()
    }
    
    func textViewDidChange(textView: UITextView) {
        //let tweet = textView.text
        //print("in text change")
        let charsRemaining = MAX_CHARS - textView.text.characters.count
        self.remainingCharsLabel.text = "\(charsRemaining)"
        self.remainingCharsLabel.textColor = charsRemaining >= 0 ? .lightGrayColor() : .redColor()
        self.adjustScrollViewContentSize()
    }
    
    func adjustScrollViewContentSize() {
        self.composeScrollView.contentSize = CGSizeMake(self.composeScrollView.frame.size.width, self.tweetTextView.frame.origin.y + self.tweetTextView.frame.size.height)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTweet(sender: AnyObject) {
        let tweet = self.tweetTextView.text
        if (tweetTextView.text.characters.count == 0) {
            return
        } else {
            let params: NSDictionary = ["status": tweet]
            
            TwitterClient.sharedInstance.postTweetWithParams(params, completion: { (tweet, error) -> () in
                if error != nil {
                    NSLog("error posting status: \(error)")
                    return
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("tweetPostedNotification", object: tweet)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        }
        
    }

        
    
    
    
    @IBAction func onCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
