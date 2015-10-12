//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/1/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetsTableViewCellDelegate {
    
    var tweets: [Tweet]?
    var hbMenuDelegate: HBMenuViewControllerDelegate?
    var isMentionsView = false
 

    
    @IBOutlet weak var tableView: UITableView!
   
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        if isMentionsView {
            navigationItem.title = "Mentions"
        } else {
            navigationItem.title = "Home"
        }
        self.tableView.reloadData()
        //tableView.estimatedRowHeight = 200
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        /*self.tableView.addPullToRefreshWithActionHandler {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (statuses, error) -> () in
                self.displayTweets()
            })
        }*/
        
       /* self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.displayTweets()
        }*/
        
        //If user posted tweet, load that first
        NSNotificationCenter.defaultCenter().addObserverForName("tweetPostedNotification", object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let tweet = notification.object as! Tweet
            self.tweets?.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
        }
        
        displayTweets()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.displayTweets()
        }
       /* self.tableView.addPullToRefreshWithActionHandler {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (statuses, error) -> () in
                self.displayTweets()
            })
        }*/
    }
    
    func displayTweets() {
        if isMentionsView {
            TwitterClient.sharedInstance.mentionsTimelineWithParams(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    return ()
                })
            })

        } else {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
                if self.tableView.pullToRefreshView != nil {
                    self.tableView.pullToRefreshView.stopAnimating()
                }
                self.tweets = tweets
                //print("Tweets count in display tweeets is \(self.tweets!.count)")
                self.tableView.reloadData()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    return ()
                })
            })

        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        //print("in cellforrow")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tweetsCell", forIndexPath: indexPath) as! TweetsTableViewCell
        
            cell.tweet = self.tweets?[indexPath.row]
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("OpenTweetViewController") as! OpenTweetViewController
        controller.tweet = self.tweets![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        //self.navigationController?.pushViewController(controller, animated: true)*/
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count is \(self.tweets!.count)")
        return self.tweets?.count ?? 0
        
    }

  
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*@IBAction func onSignOut(sender: AnyObject) {
        User.currentUser?.logout()
    }*/
    
    func showProfile1(cell: TweetsTableViewCell) {
        print("here2")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ProfViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        ProfViewController.user = cell.tweet!.user
        ProfViewController.viewWillAppear(true)
        
        
        navigationController?.presentViewController(ProfViewController, animated: true, completion: nil)
    }

   
    @IBAction func onMenuTap(sender: AnyObject) {
        hbMenuDelegate?.toggleHBMenu()
    }
    

}
