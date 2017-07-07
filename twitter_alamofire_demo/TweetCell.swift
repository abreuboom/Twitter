//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

protocol TweetCellDelegate: class {
    func didTapProfile(_ sender: UITapGestureRecognizer)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mediaView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            tweetTextLabel.numberOfLines = 0
            tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
            tweetTextLabel.backgroundColor = .white
            
            tweetTextLabel.customize { label in
                label.hashtagColor = UIColor(red: 68.0/255, green: 178.0/255, blue: 231.0/255, alpha: 1)
                label.mentionColor = UIColor(red: 68.0/255, green: 178.0/255, blue: 231.0/255, alpha: 1)
                label.URLColor = UIColor(red: 68.0/255, green: 178.0/255, blue: 231.0/255, alpha: 1)
                label.handleHashtagTap { hashtag in
                    print("Success. You just tapped the \(hashtag) hashtag")
                }
                label.handleURLTap({ (url) in
                    UIApplication.shared.openURL(url)
                })
            }
            
            
            usernameLabel.text = tweet.user.name
            handleLabel.text = "@" + tweet.user.screenName! + "  ·"
            dateLabel.text = tweet.createdAtString
            repliesLabel.text = String(0)
            retweetsLabel.text = tweet.intFormatter(x: tweet.retweetCount)
            likesLabel.text = tweet.intFormatter(x: tweet.favoriteCount!)
            profilePhotoView.af_setImage(withURL:tweet.user.profilePhotoUrl!)
            
            profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width / 2
            profilePhotoView.layer.masksToBounds = true
            
            mediaView.layer.cornerRadius = 10
            mediaView.layer.masksToBounds = true
            
            if tweet.retweeted == true {
                retweetButton.isSelected = true
            }
            else {
                retweetButton.isSelected = false
            }
            if tweet.favorited == true {
                favoriteButton.isSelected = true
            }
            else {
                favoriteButton.isSelected = false
            }
            
            if let media = tweet.media {
                let photoView = UIImageView()
                photoView.contentMode = .scaleAspectFill
                mediaView.af_setImage(withURL: media)
            }
            
        }
    }
    
    @IBAction func reply(_ sender: UIButton) {
        
    }
    
    @IBAction func retweet(_ sender: UIButton) {
        if sender.isSelected == true {
            APIManager.shared.unRetweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.retweetsLabel.text = String(Int(self.retweetsLabel.text!)! - 1)
                }
            })
            sender.isSelected = false
        }
        else {
            APIManager.shared.retweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.retweetsLabel.text = String(Int(self.retweetsLabel.text!)! + 1)
                }
            })
            sender.isSelected = true
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        if sender.isSelected == true {
            APIManager.shared.unfavoriteTweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.likesLabel.text = String(Int(self.likesLabel.text!)! - 1)
                }
            })
            sender.isSelected = false
        }
        else {
            APIManager.shared.favoriteTweet(tweet: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.likesLabel.text = String(Int(self.likesLabel.text!)! + 1)
                }
            })
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
