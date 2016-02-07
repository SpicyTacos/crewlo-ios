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
import CoreLocation

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, CLLocationManagerDelegate  {
    
    let locationManager = CLLocationManager();
    let defaults = NSUserDefaults.standardUserDefaults();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().mainBlueGradient();
        background.frame = self.view.bounds;
        self.view.layer.insertSublayer(background, atIndex: 0);

        // Do any additional setup after loading the view.
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in.");
        } else {
            print("Logged in.");
        }
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        //loginButton.center = self.view.center
        //self.view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.requestAlwaysAuthorization();
        locationManager.requestLocation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isUserLoggedIn()-> Bool {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            return false;
        } else {
            return true;
        }
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
                    })
                }
            }
        })
    }
    func getFBUserData(completion: (() -> Void)!){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let fb_id = Int(result.valueForKey("id") as! String);
                    self.defaults.setInteger(fb_id!, forKey: "fb_id");
                    completion();
                }
            })
        }
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //uhh.. i don't think this does anything but xcode won't compile without it.
    }
    func facebookLogout() {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager();
        fbLoginManager.logOut();
    }
    
    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("your dad");
//        if(error == nil){
//            print("Facebook logged in");
//        } else {
//            print("Error logging in \(error.localizedDescription)");
//        }
//        // print(result.token.tokenString);
//        
//        //Show user information
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"]);
//        
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil){
//                // Process error
//                print("Error: \(error)")
//            } else {
//                print("fetched user: \(result)")
//                let userId : Int? = Int(result.valueForKey("id") as! String)
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                print("User Email is: \(userEmail)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
//                
//                let parameters: Dictionary<String, AnyObject> = [
//                    "id": userId!,
//                    "email": userEmail,
//                    "username": userName,
//                    "facebook": true
//                ];
//                Alamofire.request(.POST, "http://Coreys-MacBook-Pro.local:3000/facebook/authorize", parameters: parameters, encoding: .JSON)
//                    .responseJSON { response in
//                        let message = response.result.value!["username"] as? String!;
//                        print(message!);
////                        // Display alert message with confirmation
////                        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert);
////                        
////                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
////                            action in
////                            self.dismissViewControllerAnimated(true, completion: nil);
////                        }
////                        
////                        myAlert.addAction(okAction);
////                        
////                        self.presentViewController(myAlert, animated: true, completion: nil);
//                }
//                
//            }
//        })
//    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out.");
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
        } else {
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
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
