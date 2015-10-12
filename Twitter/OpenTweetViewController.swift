//
//  OpenTweetViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/4/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class OpenTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Tweet"
        
        self.profileImageView.setImageWithURL(self.tweet?.user.profileImageUrl)
        //print("Profile image: \(self.tweet?.user.profileImageUrl)")
        self.profileImageView.layer.cornerRadius = 9.0
        //self.profileImageView.layer.masksToBounds = true
        self.nameLabel.text = self.tweet?.user.name
        self.screenNameLabel.text = "@\(self.tweet!.user.screenname)"
        self.tweetTextLabel.text = self.tweet?.text
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        self.dateLabel.text = formatter.stringFromDate(self.tweet!.createdAt)
        
        self.retweetsLabel.text = "\(self.tweet!.numberOfRetweets)"
        self.favoritesLabel.text = "\(self.tweet!.numberOfFavorites)"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }

    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
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
