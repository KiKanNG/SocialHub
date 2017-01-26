//
//  EditCellwithButton.swift
//  SocialHub
//
//  Created by KiKan Ng on 24/1/2017.
//
//

import UIKit

class EditCellwithButton: UITableViewCell {
    
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var infos: UITextField!
    
    @IBOutlet var numbersPic: UIImageView!
    
    @IBAction func getID(sender: AnyObject) {
        print("Button is touched")
        fbLoginInitiate()
    }
    
    func fbLoginInitiate() {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email"], handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                // Process error
                self.removeFbData()
            } else if result.isCancelled {
                // User Cancellation
                self.removeFbData()
            } else {
                //Success
                self.fetchProfile()
            }
        })
    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func fetchProfile(){
        print("fetch profile")
        
        let parameters = ["fields": "id"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{
            (connection, result, error)-> Void in
            if error != nil{
                print(error)
                return
            }
            
            if let id = result["id"] as? String{
                self.infos.allControlEvents()
                self.infos.text = id
            }
            
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Complete")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
