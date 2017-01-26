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

class FriendViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Firebase data source
    var ref = FIRDatabase.database().reference()
    var userAllInfo:[UserInfoToPage] = []
    var filteredInfo:[UserInfoToPage] = []
    var userAllFriendliness:[UserInfoToPage] = []
    var myFriendliness:Int = 0
    var onesFriendliness:Int = 0
    
    var friendID : String = ""
    var myID = DefaultsInfo.FirebaseID
    var DisplayCase = -1
    var count:Int = 0
    
    // Button
    let Button = UIButton()
    let items = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button
        Button.frame = CGRectMake(0, 0, 120, 30)    // can't live update yet
        observe()
        
        // Button.backgroundColor = UIColor.blackColor()
        Button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        Button.contentHorizontalAlignment = .Right
        Button.addTarget(self, action: #selector(FriendViewController.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        items.customView = Button
        self.navigationItem.rightBarButtonItem = items
        
        startObservingDB("users_personal_info")
        startObservingDB("users_personal_info_friendliness")
        
        ref.child("friend_list").child(friendID).child(myID!).child("friendliness").observeEventType(.Value, withBlock: { snapshot in
            if self.Button.titleLabel?.text == "Friends" {
                
                if snapshot.exists() {
                self.myFriendliness = snapshot.value as! Int
                } else {
                    self.myFriendliness = 0
                }
                
            } else {
                self.myFriendliness = 0
            }
            self.filteredInfo = self.userAllInfo
            self.filter()
            self.tableView!.reloadData()
        })
        
    }
    
    func observe() {
        Button.setTitle("Add friend", forState: .Normal)
        ObservingDBlist("friend_list", user: myID!, target: friendID, buttonText: "Friends")
        ObservingDBlist("pending_list", user: myID!, target: friendID, buttonText: "Accept")
        ObservingDBlist("pending_list", user: friendID, target: myID!, buttonText: "Requested")
    }
    
    func filter() { // can't live update yet
        
        let section = userAllInfo.count - 1
        for index in (0...section).reverse() {
            let section_layer = userAllInfo[index].infos.count - 1
            for item in (0...section_layer).reverse() {
                
                let foo:Int? = Int(userAllFriendliness[index].infos[item].description)
                print("text: \(filteredInfo[index].infos[item].description), foo: \(foo!), me: \(myFriendliness)")
                if (foo! > myFriendliness) {
                    // filteredInfo[index].infos.removeAtIndex(item)
                    filteredInfo[index].infos[item].description = ""
                }
                print("text: \(filteredInfo[index].infos[item].description)")
            }
        }
    }
    
    //action method :
    
    func action(sender:UIButton!) {
        switch Button.titleLabel!.text {
        case .Some("Add friend"):
            // add to pending list
            DisplayCase = 2
            friendlinessOrUnfriend()
            
        case .Some("Friends"):
            // select from level of friends or unfriend
            DisplayCase = 0
            friendlinessOrUnfriend()

        case .Some("Accept"):
            // select from level of friends or unfriend
            DisplayCase = 1
            friendlinessOrUnfriend()
            
        case .Some("Requested"):
            // delete from pending list
            deleteFromDB("pending_list", userID: friendID, targetID: myID!)
            
        default:
            break
        }
        
        observe()
    }
    
    func friendlinessOrUnfriend() {
        let VC = storyboard?.instantiateViewControllerWithIdentifier("popUpVC") as! PopUpViewController
        VC.friendID = friendID
        VC.DisplayCase = DisplayCase
        VC.selectedRow = onesFriendliness
        
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
    
    func ObservingDBlist(listName: String, user: String, target: String, buttonText: String) {
        ref.child(listName).child(user).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.value is NSNull {
                
            } else {
                for child in snapshot.children {
                    if child.key == target {
                        self.onesFriendliness = child.childSnapshotForPath("friendliness").value as! Int
                        self.Button.setTitle(buttonText, forState: .Normal)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func startObservingDB(listName: String) {
        let dbRef = ref.child(listName).child(friendID)
        
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                let me = UserProfile.init(snapshot: snapshot)
                switch listName {
                case "users_personal_info":
                    self.userAllInfo = me.toArrayForPage()
                    
                default:
                    self.userAllFriendliness = me.toArrayForPage()
                    // self.filter()
                }
                
                self.tableView!.reloadData()
            }
        })
    }
    
    
    @IBAction func BacktoFriendlist(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let partialInfo = filteredInfo[section]
        return partialInfo.name
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredInfo.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let partialInfo = filteredInfo[section]
        return partialInfo.infos.count
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Basic Cell", forIndexPath: indexPath) as UITableViewCell
        
        let partialInfo = filteredInfo[indexPath.section]
        let perInfo = partialInfo.infos[indexPath.row]
        
        cell.textLabel?.text = perInfo.title
        cell.detailTextLabel?.text = perInfo.description
        
        return cell
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

