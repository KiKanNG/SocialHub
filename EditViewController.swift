//
//  MeNavigationItem.swift
//  SocialHub
//
//  Created by KiKan Ng on 6/1/2017.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class EditViewController: UITableViewController, UITextFieldDelegate {
    
    var ref = FIRDatabase.database().reference()
    var userAllInfo:[UserInfoToPage] = []
    var sectionBeingEdited : Int? = nil
    var rowBeingEdited : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Buttons

    @IBAction func BackToPage(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func DoneBacktoPage(sender: AnyObject) {
        if let row = rowBeingEdited, section = sectionBeingEdited {
            let indexPath = NSIndexPath(forRow:row, inSection:section)
            if userAllInfo[indexPath.section].name == "Social Accounts" {
                
                let cell : EditCellwithButton? = self.tableView.cellForRowAtIndexPath(indexPath) as! EditCellwithButton?
                cell?.infos.resignFirstResponder()
            } else {
                
                let cell : EditCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! EditCell?
                cell?.infos.resignFirstResponder()
            }
        }
        
        let dbRef = ref.child("users_personal_info").child(DefaultsInfo.FirebaseID!)
        let update = UserProfile.init(fromPage: userAllInfo)
        dbRef.setValue(update.toJSON())
        
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
        
        if userAllInfo[indexPath.section].name == "Social Accounts" {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Editing Cell with Button", forIndexPath: indexPath) as! EditCellwithButton
            let partialInfo = userAllInfo[indexPath.section]
            let perInfo = partialInfo.infos[indexPath.row]
            
            cell.title.text = perInfo.title
            cell.infos.text = perInfo.description
            cell.infos.placeholder = "Type your \(perInfo.title)'s user ID"
            cell.infos.tag = indexPath.section * 10 + indexPath.row
            cell.infos.delegate = self
            
            return cell
            
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Editing Cell", forIndexPath: indexPath) as! EditCell
            let partialInfo = userAllInfo[indexPath.section]
            let perInfo = partialInfo.infos[indexPath.row]
            
            cell.title.text = perInfo.title
            cell.infos.text = perInfo.description
            cell.infos.placeholder = perInfo.description
            cell.infos.tag = indexPath.section * 10 + indexPath.row
            cell.infos.delegate = self
            
            return cell
        }

    }

    func textFieldDidBeginEditing(textField: UITextField) {
        let rowNUM = textField.tag % 10
        let sectionNUM = (textField.tag - rowNUM) / 10
        rowBeingEdited = rowNUM
        sectionBeingEdited = sectionNUM
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        userAllInfo[sectionBeingEdited!].infos[rowBeingEdited!].description = textField.text ?? ""
        
        rowBeingEdited = nil
        sectionBeingEdited = nil
    }
    
}