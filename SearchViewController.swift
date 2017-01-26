//
//  SearchViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 22/12/2016.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult = [User]()
    var allUsers = [User]()
    let ref = FIRDatabase.database().reference()
    let maxQueryResult = 10
    
    
    func filterContentForSearchText(searchText: String) {
        searchResult = allUsers.filter{users in
            return users.username.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your friends here"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        startObservingDB()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let upcoming:FriendViewController = segue.destinationViewController as! FriendViewController
        if let indexpath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
            if searchController.active && searchController.searchBar.text != "" {
                upcoming.friendID = searchResult[indexpath.row].uid
            } else {
                upcoming.friendID = allUsers[indexpath.row].uid
            }
        }
    }
    
    func startObservingDB() {
        let dbRef = ref.child("users_personal_info").queryOrderedByChild("username")
        dbRef.observeEventType(.Value, withBlock: {snapshot in
            
            if snapshot.value is NSNull {
                
            } else {
                self.allUsers = [User]()
                for child in snapshot.children {
                    let uid = child.key as String
                    if uid != DefaultsInfo.FirebaseID {
                        let name = child.value["username"] as? String
                        self.allUsers.append(User.init(uid: uid, username: name!, friendly: 0))
                    }

                }
            }
            self.tableView.reloadData()
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return searchResult.count
        } else {
            return (allUsers.count < maxQueryResult) ? allUsers.count : maxQueryResult
        }
    }
    
    // indexPath: which section and which row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Search Cell", forIndexPath: indexPath) as UITableViewCell
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = searchResult[indexPath.row].username
        } else {
            cell.textLabel?.text = allUsers[indexPath.row].username
        }
        
        return cell
    }
    
}


extension SearchViewController:UISearchResultsUpdating {
    func updateSearchresults(searchController : UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
