//
//  HBMenuViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/9/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class HBMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    
    
    var delegate: HBMenuViewControllerDelegate?
    var menuItems = ["Timeline", "Mentions", "Sign Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.reloadData()
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuProfileCell") as! HBMenuProfileCell
            cell.user = User.currentUser!
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HBMenuCell") as! HBMenuCell
            let text = menuItems[indexPath.row]
            cell.textLabel?.text = text
            return cell
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        
        if indexPath.section == 0 {
           delegate?.showProfile()
        } else {
            switch row {
            case 0: delegate?.showTimeline()
            case 1: delegate?.showMentions()
            case 2: delegate?.showMentions()
            default: delegate?.showTimeline()
            }
        }
        
        //menuTableView.center = CGPoint(x: menuHiddenX, y: menuOriginalCenter.y)
        //viewControllerView.center = CGPoint(x: viewControllerShownX, y: viewControllerOriginalCenter.y)
        //menuTableView.deselectRowAtIndexPath(indexPath, animated: false)

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

protocol HBMenuViewControllerDelegate {
    func toggleHBMenu()
    func showProfile()
    func showTimeline()
    func showMentions()
}

