//
//  Query.swift
//  SocialHub
//
//  Created by KiKan Ng on 3/1/2017.
//
//

import UIKit
import Firebase

// -1 means dont show
func add2DB(listName: String, userID: String, targetID: String, friendliness: Int) {
    let info : [String:[String:AnyObject]]!
    if friendliness == -1 {
        info = [userID : ["timestamp" : DefaultsInfo.timestamp]]
    } else {
        info = [userID : ["friendliness" : friendliness, "timestamp" : DefaultsInfo.timestamp]]
    }
    FIRDatabase.database().reference().child(listName).child(targetID).updateChildValues(info)
}

func deleteFromDB(listName: String, userID: String, targetID: String) {
    FIRDatabase.database().reference().child(listName).child(userID).child(targetID).removeValue()
}

func changeFriendliessDB(listName: String, userID: String, targetID: String, friendliness: Int) {
    FIRDatabase.database().reference().child(listName).child(userID).child(targetID).child("friendliness").setValue(friendliness)
}