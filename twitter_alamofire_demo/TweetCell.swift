//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            handleLabel.text = "@" + tweet.user.screenName!
            dateLabel.text = tweet.createdAtString
            repliesLabel.text = String(0)
            retweetsLabel.text = String(tweet.retweetCount)
            likesLabel.text = String(describing: tweet.favoriteCount!)
            profilePhotoView.af_setImage(withURL:tweet.user.profilePhotoUrl!)
            
            profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width / 2
            profilePhotoView.layer.masksToBounds = true
        }
    }
    
    @IBAction func reply(_ sender: UIButton) {
        
    }
    
    @IBAction func retweet(_ sender: UIButton) {
        if sender.isSelected == true {
            APIManager.shared.unfavoriteTweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("FAILED")
                }
            })
            sender.isSelected = false
        }
        else {
            APIManager.shared.favoriteTweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("FAILED")
                }
            })
            sender.isSelected = true
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
