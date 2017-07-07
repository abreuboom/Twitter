//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation
import DateToolsSwift

class Tweet {
    
    // MARK: Properties
    var id: Int64 // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    var user: User // Contains name, screenname, etc. of tweet author
    var createdAtString: String // Display date
    var media: URL?
    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        let entities = dictionary["entities"] as! [String: Any]
        if entities["media"] != nil {
            let mediaArray = entities["media"] as! [[String : Any]]
            let mediaDictionary = mediaArray[0]
            let url = mediaDictionary["media_url_https"] as! String
            media = URL(string: url)
        }
        
        
        let twitterUser = dictionary["user"] as! [String: Any]
        user = User(dictionary: twitterUser)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        
        createdAtString = date.shortTimeAgoSinceNow
//        formatter.string(from: date)
        
        
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

