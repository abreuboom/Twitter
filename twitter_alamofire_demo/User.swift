//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    // For user persistance
    var dictionary: [String: Any]?
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    var id: Int64
    var name: String
    var screenName: String?
    var description: String?
    var followers: Int?
    var following: Int?
    var profilePhotoUrl: URL?
    var backgroundPhotoUrl: URL?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        id = dictionary["id"] as! Int64
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as? String
        description = dictionary["description"] as? String
        followers = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int
        let profilePhoto = dictionary["profile_image_url_https"] as? String
        let highResProfilePhoto = profilePhoto?.replacingOccurrences(of: "normal", with: "bigger")
        
        
        profilePhotoUrl = URL(string: highResProfilePhoto!)
        if let backgroundPhoto = dictionary["profile_banner_url"] as? String {
            backgroundPhotoUrl = URL(string: backgroundPhoto)
        }
    }
    
    func intFormatter (x: Int) -> String{
        if x > 1000000 {
            return String(x/100000) + "M"
        }
        else if x > 1000 {
            return String(x/1000) + "K"
        }
        else {
            return String(x)
        }
    }
}
