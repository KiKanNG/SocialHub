//
//  FriendListViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 22/12/2016.
//
//

import UIKit
import Firebase

class FriendListViewController: UITableViewController {
    
    // MARK: - Firebase data source
    
    let ref = FIRDatabase.database().reference()
    var friendlist = [User]()
    
    // MARK: - System function
    override func viewDidLoad() {
        super.viewDidLoad()
        startObservingDB()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let upcoming:FriendViewController = segue.destinationViewController as! FriendViewController
        if let indexpath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
            upcoming.friendID = friendlist[indexpath.row].uid
        }
    }
    
    func startObservingDB() {
        
        let dbRef = ref.child("friend_list").child(DefaultsInfo.FirebaseID)
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                self.friendlist = [User]()
                for child in snapshot.children {
                    var name : String = ""
                    
                    self.ref.child("users_personal_info").child(child.key).child("username").observeEventType(.Value, withBlock: { snapshot in
                        name = snapshot.value as! String
                        for friend in self.friendlist {
                            if friend.uid == child.key {
                                friend.username = name
                                self.tableView!.reloadData()
                            }
                        }
                    })

                    self.friendlist.append(User.init(uid: child.key, username: name))
                }
                self.tableView!.reloadData()
            }
        })
        
    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendlist.count
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Friend Cell", forIndexPath: indexPath) as UITableViewCell
        
        let friend = friendlist[indexPath.row]
        cell.textLabel?.text = friend.username
        
        return cell
    }
    
}

