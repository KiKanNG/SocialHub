//
//  PopUpViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 18/1/2017.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class PopUpViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    let ref = FIRDatabase.database().reference()
    var DisplayCase = -1
    var myID = DefaultsInfo.FirebaseID
    var friendID:String = ""
    
    var friendly = ["\(friendliness.Stranger)", "\(friendliness.HiByeFriend)", "\(friendliness.Friend)", "\(friendliness.BF)", "\(friendliness.BFF)"]
    var selectedRow = 0
    let L_Button = UIButton()
    let L_items = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedRow)
        if DisplayCase == 0 {
            self.navigationItem.title = "Change friendliness"
        } else {
            self.navigationItem.title = "Choose friendliness"
        }
        
        if DisplayCase != -1 {
            friendly.append("              Unfriend")
        } else {
            friendly.append("              Show all")
        }
        
        // L_Button
        L_Button.frame = CGRectMake(0, 0, 60, 30)
        L_Button.setTitle("Cancel", forState: .Normal)
        L_Button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        L_Button.contentHorizontalAlignment = .Left
        L_Button.addTarget(self, action: #selector(PopUpViewController.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        L_items.customView = L_Button
        self.navigationItem.leftBarButtonItem = L_items
        }
    
    func Cancel(sender:UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func Save2DB(Index: Int) {
        switch DisplayCase {
        case 0: // already friends
            
            changeFriendliessDB("friend_list", userID: myID!, targetID: friendID, friendliness: Index)
            
        case 1: // Accept
            
            // add to both friend list
            add2DB("friend_list", userID: myID!, targetID: friendID, friendliness: 0)
            add2DB("friend_list", userID: friendID, targetID: myID!, friendliness: Index)
            // delete from pending list
            deleteFromDB("pending_list", userID: myID!, targetID: friendID)
            
        case 2: // Add friend
            
            add2DB("pending_list", userID: myID!, targetID: friendID, friendliness: Index)
            
        case -1: // FriendList
            DefaultsInfo.FriendListData = Index
            
        default:
            break
        }
    }
    
    func confirm() {
        let alertController = UIAlertController(title: "Think Twice", message: "Are you SURE?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "I am damn sure!", style: .Destructive, handler: okHandler)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func okHandler(alert: UIAlertAction!) {
        switch DisplayCase {
        case 0: // already friends
            
            deleteFromDB("friend_list", userID: myID!, targetID: friendID)
            deleteFromDB("friend_list", userID: friendID, targetID: myID!)
            
        case 1: // Accept
            
            deleteFromDB("pending_list", userID: myID!, targetID: friendID)
            
        default:
            break
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendly.count
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PopOver", forIndexPath: indexPath) as UITableViewCell
        
        let friend = friendly[indexPath.row]
        cell.textLabel?.text = friend
        cell.imageView?.image = UIImage(named: "\(indexPath.row + 1)")
        
        if friendly[indexPath.row] == "              Unfriend" {
            cell.textLabel?.textColor = UIColor.redColor()
        }
        
        if indexPath.row == selectedRow {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let path = NSIndexPath(forRow: selectedRow, inSection: 0)
        let prevCell = tableView.cellForRowAtIndexPath(path)
        
        selectedRow = indexPath.row
        prevCell?.accessoryType = UITableViewCellAccessoryType.None
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        if cell?.textLabel?.text != "              Unfriend" {
            Save2DB(indexPath.row)
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            confirm()
        }
    }

}


