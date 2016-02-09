//
//  ViewControllerF.swift
//  Crewlo
//
//  Created by Corey Howell on 12/31/15.
//  Copyright © 2015 Crewlo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Alamofire

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    var overlay: UIView?;
    var overlayStatusLabel = UILabel(frame: CGRectMake(0, 0, 200, 21));
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setBackground();
        
        initFacebookDelegate();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground() {
        let background = CAGradientLayer().mainBlueGradient();
        background.frame = self.view.bounds;
        self.view.layer.insertSublayer(background, atIndex: 0);
    }
    
    func isUserFbTokenValid()-> Bool {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            return false;
        } else {
            return true;
        }
    }
    
    func login(completion: (()-> Void)!) {
        let fb_id : Int? = Int(defaults.objectForKey("fb_id") as! Int);
        let email : String? = String(defaults.objectForKey("email") as! String);
        let username : String? = String(defaults.objectForKey("username") as! String);
        let parameters: Dictionary<String, AnyObject> = [
            "fb_id": fb_id!,
            "email": email!,
            "username": username!,
            "facebook": true
        ];
        Alamofire.request(.POST, "http://Coreys-MacBook-Pro.local:3000/facebook/authorize", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                let message = response.result.value!["username"] as? String!;
                let user_id = response.result.value!["user_id"] as? Int!;
                self.defaults.setInteger(user_id!, forKey: "user_id");
                print(message!);
                completion();
        }
    }
    
    func toggleLoadingOverlay(value: Bool, message: String?) {
        if (value) {
            overlay = UIView(frame: view.frame)
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.8
            view.addSubview(overlay!)
            activityIndicatorView.startAnimating()
            
            if ((message) != nil) {
                overlayStatusLabel.center = self.view.center;
                overlayStatusLabel.textAlignment = NSTextAlignment.Center
                overlayStatusLabel.text = message!;
                overlayStatusLabel.textColor = UIColor.whiteColor();
                view.addSubview(overlayStatusLabel)
            }
            
            print(NSUserDefaults.standardUserDefaults().objectForKey("fb_id"));
        } else {
            activityIndicatorView.stopAnimating()
            overlay!.removeFromSuperview();
            overlayStatusLabel.removeFromSuperview();
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
    
    // MARK: - Lock Orientation
    // as of right now, the login page doesn't work in landscape mode.
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    // MARK: - FBSDK Delegate
    func initFacebookDelegate() {
        let loginButton: FBSDKLoginButton = FBSDKLoginButton();
        loginButton.readPermissions = ["public_profile", "email", "user_friends"];
        loginButton.delegate = self;
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //required method of FBSDK delegate
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out.");
        //required method of FBSDK delegate
    }
    
    func getFBUserData(completion: (() -> Void)!){
        let message = "Logging you in!";
        toggleLoadingOverlay(true, message: message);
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let fb_id = Int(result.valueForKey("id") as! String);
                    let username = result.valueForKey("name") as! String;
                    print(username);
                    let email = result.valueForKey("email") as! String;
                    self.defaults.setInteger(fb_id!, forKey: "fb_id");
                    self.defaults.setObject(username, forKey: "username");
                    self.defaults.setObject(email, forKey: "email");
                    self.login(completion);
                }
            })
        }
    }
    
    func facebookLogout() {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager();
        fbLoginManager.logOut();
    }
    
    @IBAction func facebookLoginButtonPressed(sender: AnyObject) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager();
        fbLoginManager .logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: {(result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result;
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData({
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
                        appDelegate.homePage("MainStreamViewID");
                        self.self.toggleLoadingOverlay(false, message: nil);
                    })
                }
            }
        })
    }

}
