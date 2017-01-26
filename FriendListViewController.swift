//
//  FriendListViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 22/12/2016.
//
//

import UIKit
import Firebase

class FriendListViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Firebase data source
    
    let ref = FIRDatabase.database().reference()
    var friendlist = [User]()
    var filteredlist = [User]()
    
    // Right Button
    let Button = UIButton()
    let items = UIBarButtonItem()
    
    // MARK: - System function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Button
        Button.frame = CGRectMake(0, 0, 120, 30)
        Button.setTitle("Sort", forState: .Normal)  // Or should it calls Friendliness?
        Button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        Button.contentHorizontalAlignment = .Right
        Button.addTarget(self, action: #selector(FriendViewController.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        items.customView = Button
        self.navigationItem.rightBarButtonItem = items
        
        startObservingDB()
        //filtering()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let upcoming:FriendViewController = segue.destinationViewController as! FriendViewController
        if let indexpath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
            upcoming.friendID = filteredlist[indexpath.row].uid
        }
    }
    
    func action(sender:UIButton!) {
        let VC = storyboard?.instantiateViewControllerWithIdentifier("popUpVC") as! PopUpViewController
        
        VC.preferredContentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 260)
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = navController.popoverPresentationController
        popover?.delegate = self
        
        popover?.sourceView = self.view
        popover?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection()
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func filtering() {
        let Index = DefaultsInfo.FriendListData
        filteredlist = friendlist.filter{ (user : User) -> Bool in
            return (Index != 5) ? (user.friend.hashValue == Index) : true
        }
        tableView.reloadData()
    }
    
    func startObservingDB() {
        
        let dbRef = ref.child("friend_list").child(DefaultsInfo.FirebaseID!)
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                self.friendlist = [User]()
                for child in snapshot.children {
                    var name : String = ""
                    var friend : Int = 0
                    
                    self.ref.child("users_personal_info").child(child.key).child("username").observeEventType(.Value, withBlock: { snapshot in
                        name = snapshot.value as! String
                        for friend in self.friendlist {
                            if friend.uid == child.key {
                                friend.username = name
                                self.tableView!.reloadData()
                            }
                        }
                    })
                    
                    friend = (child.value["friendliness"] as! NSNumber).integerValue
                    self.friendlist.append(User.init(uid: child.key, username: name, friendly: friend))
                }
                self.filteredlist = self.friendlist
                self.tableView!.reloadData()
            }
        })
        
    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredlist.count
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Friend Cell", forIndexPath: indexPath) as UITableViewCell
        
        let friend = filteredlist[indexPath.row]
        cell.textLabel?.text = friend.username
        cell.imageView?.image = UIImage(named: "\(friend.friend.hashValue + 1)")
        
        return cell
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

