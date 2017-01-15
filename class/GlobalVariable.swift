//
//  GlobalVariable.swift
//  SocialHub
//
//  Created by KiKan Ng on 24/12/2016.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

// MARK: - Global Variable
struct DefaultsInfo {
    static let defaults = NSUserDefaults.standardUserDefaults()
    static let userID = "0001"
    static let FirebaseID = "c6wNkUZyBoe35svDVOjtjCywwAy1"
    static var timestamp:Double {
        return NSDate().timeIntervalSince1970 * 1000
    }
    // static let FirebaseID = DefaultsInfo.defaults.stringForKey(DefaultsInfo.userID)
}

// MARK: - Class "User"
class User {
    var uid:String
    var username:String
    var email:String
    
    init (uid: String, username:String, email:String = "") {
        self.uid = uid
        self.username = username
        self.email = email
    }
    
    init (userData:FIRUser) {
        uid = userData.uid
        username = userData.displayName!
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
}

// MARK: - Class "UserProfile"
// items is defined in PersonalInfo.swift
class UserProfile {
    
    var uid:String
    var username:items
    // SocialAccounts
    var SocialAccounts_Facebook:items
    var SocialAccounts_Instagram:items
    var SocialAccounts_LinkedIn:items
    // PersonalInfo
    var PersonalInfo_Phone_Personal:items
    var PersonalInfo_Phone_Business:items
    var PersonalInfo_Email_Gmail:items
    var PersonalInfo_Email_iCloud:items
    var PersonalInfo_Email_School:items
    
    
    
    init (uid:String, username:String, Facebook:String = "", Instagram:String = "", LinkedIn:String = "", Phone_Personal:String = "", Phone_Business:String = "", Email_Gmail:String = "", Email_iCloud:String = "", Email_School:String = "")
    {
        self.uid = uid
        self.username = items.init(titled: "name", description: username)
        self.SocialAccounts_Facebook = items.init(titled: "Facebook", description: Facebook)
        self.SocialAccounts_Instagram = items.init(titled: "Instagram", description: Instagram)
        self.SocialAccounts_LinkedIn = items.init(titled: "LinkedIn", description: LinkedIn)
        self.PersonalInfo_Phone_Personal = items.init(titled: "Personal", description: Phone_Personal)
        self.PersonalInfo_Phone_Business = items.init(titled: "Business", description: Phone_Business)
        self.PersonalInfo_Email_Gmail = items.init(titled: "Gmail", description: Email_Gmail)
        self.PersonalInfo_Email_iCloud = items.init(titled: "iCloud", description: Email_iCloud)
        self.PersonalInfo_Email_School = items.init(titled: "School", description: Email_School)
    }
    
    
    init (fromPage: [UserInfoToPage]) {
        self.uid = DefaultsInfo.FirebaseID
        self.username = fromPage[0].infos[0]
        self.SocialAccounts_Facebook = fromPage[1].infos[0]
        self.SocialAccounts_Instagram = fromPage[1].infos[1]
        self.SocialAccounts_LinkedIn = fromPage[1].infos[2]
        self.PersonalInfo_Phone_Personal = fromPage[2].infos[0]
        self.PersonalInfo_Phone_Business = fromPage[2].infos[1]
        self.PersonalInfo_Email_Gmail = fromPage[3].infos[0]
        self.PersonalInfo_Email_iCloud = fromPage[3].infos[1]
        self.PersonalInfo_Email_School = fromPage[3].infos[2]
    }
    
    
    init (snapshot:FIRDataSnapshot) {
        
        uid = snapshot.value!["uid"] as! String
        username = items.init(titled: "name", description: snapshot.value!["username"] as? String)
        SocialAccounts_Facebook = items.init(titled: "Facebook")
        SocialAccounts_Instagram = items.init(titled: "Instagram")
        SocialAccounts_LinkedIn = items.init(titled: "LinkedIn")
        PersonalInfo_Phone_Personal = items.init(titled: "Personal")
        PersonalInfo_Phone_Business = items.init(titled: "Business")
        PersonalInfo_Email_Gmail = items.init(titled: "Gmail")
        PersonalInfo_Email_iCloud = items.init(titled: "iCloud")
        PersonalInfo_Email_School = items.init(titled: "School")
        
        if let this_UserSocialAccounts = snapshot.value!["UserSocialAccounts"] as? [String:AnyObject] {
            SocialAccounts_Facebook.changeDes(this_UserSocialAccounts["Facebook"] as! String)
            SocialAccounts_Instagram.changeDes(this_UserSocialAccounts["Instagram"] as! String)
            SocialAccounts_LinkedIn.changeDes(this_UserSocialAccounts["LinkedIn"] as! String)
        }

        if let this_UserPhoneNo = snapshot.childSnapshotForPath("UserPersonalInfo").value!["PhoneNo"] as? [String:AnyObject] {
            PersonalInfo_Phone_Personal.changeDes(this_UserPhoneNo["Personal"] as! String)
            PersonalInfo_Phone_Business.changeDes(this_UserPhoneNo["Business"] as! String)
        }
        
        if let this_UserEmail = snapshot.childSnapshotForPath("UserPersonalInfo").value!["Email"] as? [String:AnyObject] {
            PersonalInfo_Email_Gmail.changeDes(this_UserEmail["Gmail"] as! String)
            PersonalInfo_Email_iCloud.changeDes(this_UserEmail["iCloud"] as! String)
            PersonalInfo_Email_School.changeDes(this_UserEmail["School"] as! String)
        }
    }

    func toJSON() -> AnyObject {
        let SocialAccounts = [
            SocialAccounts_Facebook.title:SocialAccounts_Facebook.description,
            SocialAccounts_Instagram.title:SocialAccounts_Instagram.description,
            SocialAccounts_LinkedIn.title:SocialAccounts_LinkedIn.description
        ]
        
        let PersonalInfo_PhoneNo = [
            PersonalInfo_Phone_Personal.title:PersonalInfo_Phone_Personal.description,
            PersonalInfo_Phone_Business.title:PersonalInfo_Phone_Business.description
        ]
        
        let PersonalInfo_Email = [
            PersonalInfo_Email_Gmail.title:PersonalInfo_Email_Gmail.description,
            PersonalInfo_Email_iCloud.title:PersonalInfo_Email_iCloud.description,
            PersonalInfo_Email_School.title:PersonalInfo_Email_School.description
        ]
        
        let PersonlInfo = ["PhoneNo":PersonalInfo_PhoneNo, "Email":PersonalInfo_Email]
        
        return ["uid":uid, "username":username.description, "UserSocialAccounts":SocialAccounts, "UserPersonalInfo":PersonlInfo]
    }
    
    func toArrayForPage() -> [UserInfoToPage] {
        // SocialAccounts_Facebook.description = "http://facebook.com/\(SocialAccounts_Facebook.description)" ?? ""
        
        let BasicInfo = [username]
        let SocialAccounts = [SocialAccounts_Facebook, SocialAccounts_Instagram, SocialAccounts_LinkedIn]
        let PhoneNo = [PersonalInfo_Phone_Personal, PersonalInfo_Phone_Business]
        let Email = [PersonalInfo_Email_Gmail, PersonalInfo_Email_iCloud, PersonalInfo_Email_School]
        
        let BasicInfo_ = UserInfoToPage.init(name: "My Informations", infos: BasicInfo)
        let SocialAccounts_ = UserInfoToPage.init(name: "Social Accounts", infos: SocialAccounts)
        let PhoneNo_ = UserInfoToPage.init(name: "Phone Numbers", infos: PhoneNo)
        let Email_ = UserInfoToPage.init(name: "Email Address", infos: Email)

        return [BasicInfo_, SocialAccounts_, PhoneNo_, Email_]
    }
}
