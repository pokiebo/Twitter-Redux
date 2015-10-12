//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 9/29/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit


let kTwitterConsumerKey = "ZZraqB9YMB4LCLL40j4aX2Dn2"
let kTwitterConsumerSecret = "F53rbFh5F4O5jNCycsulC0exp5yA51Ya77LnR5akCJcmLjxDaA"
let kTwitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance: TwitterClient = TwitterClient(baseURL: kTwitterBaseURL, consumerKey:kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
        }
        return Static.instance
    }
    
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            //print("Tweet count is \(tweets.count)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/mentions_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            //print("Tweet count is \(tweets.count)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }

    func postTweetWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error posting tweet")
                completion(tweet: nil, error: error)
        }
    }
    
    
    func postFavoriteWithParams(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print(id)
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("posted favorite")
            completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error posting favorite")
                completion(error: error)
            }
        )}


    func postRetweetWithParams(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print(id)
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("posted retweet")
            completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error retweeting")
                completion(error: error)
            }
        )}
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL:NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }

    
    
    func getURLResponse(url: NSURL) {
        
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                //print("USER \(response)")
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    
    
    /*func openURL(url: NSURL) {
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }*/


}
