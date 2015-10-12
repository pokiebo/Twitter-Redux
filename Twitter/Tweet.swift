//
//  Tweet.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 9/29/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var id: Int?
    var user: User
    var text: String
    var createdAt: NSDate
    var numberOfRetweets: Int
    var numberOfFavorites: Int
    var isFavorited: Bool?
    var isRetweeted: Bool?
    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
        self.text = dictionary["text"] as! String
        self.id = dictionary["id"] as? Int
        
        //print("id is \(self.id)")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(dictionary["created_at"] as! String)!
        self.isFavorited = dictionary["favorited"] as? Bool
        self.isRetweeted = dictionary["retweeted"] as? Bool
        self.numberOfRetweets = dictionary["retweet_count"] as! Int
        self.numberOfFavorites = dictionary["favorite_count"] as! Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

}