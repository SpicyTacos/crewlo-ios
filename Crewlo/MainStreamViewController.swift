//
//  MainStreamViewController.swift
//  Crewlo
//
//  Created by Corey Howell on 1/10/16.
//  Copyright © 2016 Crewlo. All rights reserved.
//

import UIKit
import Social
import Alamofire

class MainStreamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    let defaults = NSUserDefaults.standardUserDefaults();
    var user: User?;
    
    let textCellIdentifier = "TextCell"
    
    var posts = [Post]();
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User();
            
        tableView.delegate = self;
        tableView.dataSource = self;
        loadPosts();
        
        
        user!.requestLocation();
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row];
        cell.bodyLabel.text = post.body;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let post = indexPath.row
        print(post);
    }
    
    func tableView(tableView:UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150.00;
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return UITableViewAutomaticDimension;
    }

    @IBAction func fbLogoutButtonPressed(sender: AnyObject) {
        LoginViewController().facebookLogout();
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.homePage("LoginViewControllerID");
    }
    
    func loadPosts() {
//        let post1 = Post(body: "Caprese Salad alsk djf oasi dfisu bflsjdf oasjdf lkjasl dkfja;sd fjopas if jo;e wfjh awiu ehfa shfosadhfi usdhf lsh dgfi usdh giu rh go;ahsg ;ahsdg li usdf hgk jshdf gkashd fgiuas dfhgo;a Caprese Salad alsk djf oasi dfisu bflsjdf oasjdf lkjasl dkfja;sd fjopas if jo;e wfjh awiu ehfa shfosadhfi usdhf lsh dgfi usdh giu rh go;ahsg ;ahsdg li usdf hgk jshdf gkashd fgiuas dfhgo;a Caprese Salad alsk djf oasi dfisu bflsjdf oasjdf lkjasl dkfja;sd fjopas if jo;e wfjh awiu ehfa shfosadhfi usdhf lsh dgfi usdh giu rh go;ahsg ;ahsdg li usdf hgk jshdf gkashd fgiuas dfhgo;a Caprese Salad alsk djf oasi dfisu bflsjdf oasjdf lkjasl dkfja;sd fjopas if jo;e wfjh awiu ehfa shfosadhfi usdhf lsh dgfi usdh giu rh go;ahsg ;ahsdg li usdf hgk jshdf gkashd fgiuas dfhgo;a Caprese Salad")
//        
//        let post2 = Post(body: "Chicken and Potatoes")
//        
//        let post3 = Post(body: "Pasta with Meatballs")
//        posts += [post1, post2, post3];
        
        Alamofire.request(.GET, "http://Coreys-MacBook-Pro.local:3000/api/v1/posts/\(user!.getId())")
            .responseJSON { response in
                //let posts: NSAnyObject = response.result.value as! NSArray! as [AnyObject];
                //THIS IS SUPER BROKEN BECAUSE WE BASICALLY NEED TO LOOP THROUGH OUR RAW POSTS AND MAKE NEW POST() OUT OF THEM.
                print(response.result.value as! [AnyObject]);
//                let raw = response.result.value as! [AnyObject];
//                let refined = raw as! [Post];
//                print(refined);
                //self.posts = posts as! [Post];
                self.tableView.reloadData();
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NewPostSegue") {
            if let destination = segue.destinationViewController as? NewPostViewController {
                destination.user = self.user;
            }
        }
    }

}
