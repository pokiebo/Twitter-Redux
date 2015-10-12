//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/8/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, HBMenuViewControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    private var tweetsNavController: UINavigationController!
    private var profileViewController: ProfileViewController!
    private var menuViewController: HBMenuViewController!
    private var mentionsNavController: UINavigationController!
    var menuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        tweetsNavController = (mainStoryboard.instantiateViewControllerWithIdentifier("tweetsNavController") as! UINavigationController)
        let tweetsViewController = tweetsNavController!.childViewControllers[0] as! TweetsViewController
        tweetsViewController.hbMenuDelegate = self
        displayViewController(tweetsNavController!)
        
        
        menuViewController = storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as? HBMenuViewController
        menuViewController.delegate = self
        view.insertSubview(menuViewController!.view, atIndex: 0)
        addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(self)
        //displayViewController(tweetsNavController!)
        
        
        profileViewController = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.isModal = false
        profileViewController.delegate = self
        

        mentionsNavController = mainStoryboard.instantiateViewControllerWithIdentifier("tweetsNavController") as! UINavigationController
        let tweetsVC = mentionsNavController.childViewControllers[0] as! TweetsViewController
        tweetsVC.isMentionsView = true
        tweetsVC.hbMenuDelegate = self
        
        
        //displayViewController(tweetsNavController!)
        
        // ADD GESTURES
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePan:")
        edgePanGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgePanGesture)

    
       
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return menuOpen
    }


    func displayViewController(vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        
    }
    
    func toggleHBMenu() {
        animateHBMenu(isOpen: !menuOpen)
    }
    
    func showProfile() {
        profileViewController.user = User.currentUser!
        displayViewController(profileViewController)

    }
    func showTimeline() {
        displayViewController(tweetsNavController)
        animateHBMenu(isOpen: false)
    }
    func showMentions() {
        displayViewController(mentionsNavController)
        animateHBMenu(isOpen: false)
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.containerView.frame.origin.x = targetPosition
            }, completion: completion)
    
    }


    func animateHBMenu(isOpen isOpen: Bool) {
        if (isOpen) {
            self.menuOpen = true
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(containerView.frame) - 150)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.menuOpen = false
                
                //   UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            }
        }
    
    }

    func handleTapGesture(sender: UITapGestureRecognizer) {
        print("in Tap")
        if (sender.state == .Ended) {
            animateHBMenu(isOpen: false)
        }
    }
    
    func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        print("in edge pan")
        NSLog("edgePan: \(sender.state)")
        if sender.state == UIGestureRecognizerState.Ended {
            animateHBMenu(isOpen: true)
        }
    }

    
    @IBAction func onPan(sender: AnyObject) {
        let point = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            animateHBMenu(isOpen: !menuOpen)
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
