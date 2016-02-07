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
    let textCellIdentifier = "TextCell"
    
    var posts = [Post]();
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.delegate = self;
        tableView.dataSource = self;
        loadSamplePosts();
        loggingIn();
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        LoginViewController().viewDidLoad();
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = posts[row].body;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(posts[row])
    }

    @IBAction func fbLogoutButtonPressed(sender: AnyObject) {
        LoginViewController().facebookLogout();
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.homePage("LoginViewControllerID");
    }
    
    func loadSamplePosts() {
        let post1 = Post(body: "Caprese Salad")
        
        let post2 = Post(body: "Chicken and Potatoes")
        
        let post3 = Post(body: "Pasta with Meatballs")
        posts += [post1, post2, post3];
    }
    
    func loggingIn() {
        var overlay: UIView?
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.8
        view.addSubview(overlay!)
        print(NSUserDefaults.standardUserDefaults().objectForKey("fb_id"));
        
        let fb_id : Int? = Int(defaults.objectForKey("fb_id") as! Int)
        let parameters: Dictionary<String, AnyObject> = [
                                "fb_id": fb_id!,
//                                "email": userEmail,
//                                "username": userName,
                                "facebook": true
                            ];
        Alamofire.request(.POST, "http://Coreys-MacBook-Pro.local:3000/facebook/authorize", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                let message = response.result.value!["username"] as? String!;
                print(message!);
                overlay!.removeFromSuperview();
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
