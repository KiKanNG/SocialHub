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

class MeViewController: UITableViewController {
    
    // MARK: - Firebase data source
    var ref = FIRDatabase.database().reference()
    var userAllInfo = [UserInfoToPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObservingDB()
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Edit") {
            let upcoming:EditViewController = segue.destinationViewController as! EditViewController
            upcoming.userAllInfo = userAllInfo
        }
    }
    
    func startObservingDB() {
        let dbRef = ref.child("users_personal_info").child(DefaultsInfo.FirebaseID)
        
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
            let me = UserProfile.init(snapshot: snapshot)
            self.userAllInfo = me.toArrayForPage()
            self.tableView!.reloadData()
            }
        })
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
        
        /*if (perInfo.description.characters.count > 9) {
         if (perInfo.description.substringToIndex(8)? == "http://") {
         cell.detailTextLabel?.text = NSURL(string: perInfo.description)
         } else {
         cell.detailTextLabel?.text = perInfo.description
         }
         } else {
         cell.detailTextLabel?.text = perInfo.description
         }*/
        
        return cell
    }

    
}

