//
//  User.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 9/29/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

import Foundation
class User: NSObject {
    
    var name: String
    var screenname: String
    var profileImageUrl: NSURL
    var tagline: String
    var numTweets: Int
    var numFollowers: Int
    var numFollowing: Int
    var largeProfileImageUrl: NSURL
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.name = dictionary["name"] as! String
        self.screenname = dictionary["screen_name"] as! String
        self.profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as! String).stringByReplacingOccurrencesOfString("_normal", withString: "_bigger"))!
        self.tagline = dictionary["description"] as! String
        self.numTweets = dictionary["statuses_count"] as! Int
        self.numFollowers = dictionary["followers_count"] as! Int
        self.numFollowing = dictionary["friends_count"] as! Int
        self.largeProfileImageUrl = NSURL(string: (dictionary["profile_image_url"] as! String).stringByReplacingOccurrencesOfString("_normal", withString: ""))!
        
        
    }
    
 
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        if let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary {
                            _currentUser = User(dictionary: dictionary)
                            }
                        } catch _ {
                        print("Could not unwrap")
                    }
                }
            }
        return _currentUser
        }
        
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    
}
