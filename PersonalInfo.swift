//
//  PersonalInfo.swift
//  SocialHub
//
//  Created by KiKan Ng on 6/1/2017.
//
//

import Foundation

public enum friendliness
{
    case Stranger
    case HiByeFriend
    case Friend
    case BF
    case BFF
}

class items
{
    var title: String
    var description: String
    var rating: friendliness
    
    init(titled: String, description: String? = "")
    {
        self.title = titled
        self.description = description!
        rating = .Stranger
    }
    
    func changeDes(description: String) {
        self.description = description
    }
}


// assistance class
class UserInfoToPage {
    var name: String
    var infos: [items]
    
    init(name:String, infos:[items]) {
        self.name = name
        self.infos = infos
    }
}