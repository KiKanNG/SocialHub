//
//  Query.swift
//  SocialHub
//
//  Created by KiKan Ng on 3/1/2017.
//
//

import UIKit
import Firebase
/*
var ref = FIRDatabase.database().reference()

func Query(userID: String) -> UserProfile {
    var myself = UserProfile(username: "")
    var SocialAccounts = [String]()
    let JSON = ref.child("users_personal_info").child(userID)
    
    let JSON_username = JSON.child("username")
    let JSON_SocialAccounts = JSON.child("UserSocialAccounts")
    let JSON_PhoneNo = JSON.child("UserPersonalInfo").child("PhoneNo")
    let JSON_Email = JSON.child("UserPersonalInfo").child("Email")
    
    // username
    JSON_username.observeEventType(.Value, withBlock: {snapshot in
        
        if snapshot.value is NSNull {
            
        } else {
            for child in snapshot.children {
                let name = child.value["name"] as? String
                myself.username = name!
            }
        }
    })
    
    // SocialAccounts
    JSON_SocialAccounts.observeEventType(.Value, withBlock: {snapshot in
        
        if snapshot.value is NSNull {
            
        } else {
            for child in snapshot.children {
                let name = child.value["name"] as? String
                SocialAccounts.append(name!)
            }
        }
    })
    
    return myself
}
 */