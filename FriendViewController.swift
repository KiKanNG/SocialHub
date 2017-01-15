//
//  MeViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 22/12/2016.
//
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FriendViewController: UITableViewController {
    
    // MARK: - Firebase data source
    var ref = FIRDatabase.database().reference()
    var userAllInfo:[UserInfoToPage] = []
    
    var friendID : String = ""
    var friendName : String!
    var myID = DefaultsInfo.FirebaseID
    var myName : String!
    
    // Button
    let Button = UIButton()
    let items = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button
        Button.frame = CGRectMake(0, 0, 120, 30)
        Button.setTitle("Add friend", forState: .Normal)

        ObservingDBlist("friend_list", user: myID, target: friendID, buttonText: "Friends")
        ObservingDBlist("pending_list", user: myID, target: friendID, buttonText: "Accept")
        ObservingDBlist("pending_list", user: friendID, target: myID, buttonText: "Requested")

        // Button.backgroundColor = UIColor.blackColor()
        Button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        Button.contentHorizontalAlignment = .Right
        Button.addTarget(self, action: #selector(FriendViewController.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        items.customView = Button
        self.navigationItem.rightBarButtonItem = items
        
        startObservingDB()
        
        ref.child("users_personal_info").child(myID).child("username").observeEventType(.Value, withBlock: { snapshot in
            self.myName = snapshot.value as! String
        })
        
        ref.child("users_personal_info").child(friendID).child("username").observeEventType(.Value, withBlock: { snapshot in
            self.friendName = snapshot.value as! String
        })
    }
    
    //action method :
    
    func action(sender:UIButton!) {
        switch Button.titleLabel!.text {
        case .Some("Add friend"):
            // add to pending list
            add2DB("pending_list", userID: myID, userName: myName, targetID: friendID)
            
        case .Some("Friends"):
            print("sth")
            // select from level of friends or unfriend
            
        case .Some("Accept"):
            // add to both friend list
            add2DB("friend_list", userID: myID, userName: myName, targetID: friendID)
            add2DB("friend_list", userID: friendID, userName: friendName, targetID: myID)
            // delete from pending list
            deleteFromDB("pending_list", userID: myID, targetID: friendID)
            
        case .Some("Requested"):
            // delete from pending list
            deleteFromDB("pending_list", userID: friendID, targetID: myID)

        default:
            break
        }
    }
    
    func add2DB(listName: String, userID: String, userName: String, targetID: String) {
        let info = [userID : ["username" : userName, "timestamp" : DefaultsInfo.timestamp]]
        ref.child(listName).child(targetID).updateChildValues(info)
    }
    
    func deleteFromDB(listName: String, userID: String, targetID: String) {
        ref.child(listName).child(userID).child(targetID).removeValue()
    }
    
    func ObservingDBlist(listName: String, user: String, target: String, buttonText: String) {
        ref.child(listName).child(user).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                for child in snapshot.children {
                    if child.key == target {
                        self.Button.setTitle(buttonText, forState: .Normal)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func startObservingDB() {
        let dbRef = ref.child("users_personal_info").child(friendID)
        
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                let me = UserProfile.init(snapshot: snapshot)
                self.userAllInfo = me.toArrayForPage()
                self.tableView!.reloadData()
            }
        })
    }
    
    
    @IBAction func BacktoFriendlist(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let partialInfo = userAllInfo[section]
        return partialInfo.name
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userAllInfo.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let partialInfo = userAllInfo[section]
        return partialInfo.infos.count
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Basic Cell", forIndexPath: indexPath) as UITableViewCell
        
        let partialInfo = userAllInfo[indexPath.section]
        let perInfo = partialInfo.infos[indexPath.row]
        
        cell.textLabel?.text = perInfo.title
        cell.detailTextLabel?.text = perInfo.description

        return cell
    }
    
    
}

