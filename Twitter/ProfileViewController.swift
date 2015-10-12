//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/10/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User!
    var delegate: HBMenuViewControllerDelegate?
    var isModal = true
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var numTweetsLAbel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (user != nil) {
            showUserProfile()
        }
        
        self.navBar.topItem?.title = "Profile"
        if !isModal {
            self.navBarButton.title = "Menu"
        }


        // Do any additional setup after loading the view.
    }
    
    func showUserProfile() {
        self.profileImage.setImageWithURL(user.largeProfileImageUrl)
        self.profileImage.alpha = 0.6
        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@\(user.screenname)"
        
        self.numTweetsLAbel.text = "\(user.numTweets)"
        self.followersLabel.text = "\(user.numFollowers)"
        self.followingLabel.text = "\(user.numFollowing)"
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDoneTapped (){
        print("here")
        if isModal {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            delegate?.toggleHBMenu()
        }
    }
    
    
    @IBAction func onDoneTap(sender: UIBarButtonItem) {
        if isModal {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            delegate?.toggleHBMenu()
        }
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
