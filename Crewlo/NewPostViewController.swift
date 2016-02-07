//
//  NewPostViewController.swift
//  Crewlo
//
//  Created by Corey Howell on 2/4/16.
//  Copyright © 2016 Crewlo. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var TextViews: UITextView!
    @IBOutlet weak var createNewPostButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createNewPostButton.enabled = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeNewPostViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func createNewPost(sender: AnyObject) {
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
//        if (text == "\n") {
//            TextViews.resignFirstResponder();
//            return false;
//        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView) {
        if (TextViews.text.characters.count >= 1) {
            createNewPostButton.enabled = true;
        } else {
            createNewPostButton.enabled = false;
        }
        print("brrr");
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        TextViews.resignFirstResponder();
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
