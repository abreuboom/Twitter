//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by John Abreu on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, TweetCellDelegate {

    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweetData()
        
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width / 2
        profilePhotoView.layer.masksToBounds = true


        // Do any additional setup after loading the view.
    }
    
    func loadTweetData() {
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTapProfile(_:)))
        tapped.numberOfTapsRequired = 1
        profilePhotoView?.addGestureRecognizer(tapped)
        
        tweetLabel.text = tweet?.text
        nameLabel.text = tweet?.user.name
        let screenName = tweet?.user.screenName
        screenNameLabel.text = "@" + screenName!
        dateLabel.text = tweet?.createdAtString
        let retweetCount = tweet?.retweetCount
        retweetLabel.text = String(describing: retweetCount!)
        let favoriteCount = tweet?.favoriteCount
        likeLabel.text = String(describing: favoriteCount!)
        
        let profilePhotoURL = tweet?.user.profilePhotoUrl
        profilePhotoView.af_setImage(withURL: profilePhotoURL!)
        
        if tweet?.retweeted == true {
            retweetButton.isSelected = true
        }
        else {
            retweetButton.isSelected = false
        }
        if tweet?.favorited == true {
            favoriteButton.isSelected = true
        }
        else {
            favoriteButton.isSelected = false
        }
    }

    @IBAction func retweet(_ sender: UIButton) {
        if sender.isSelected == true {
            APIManager.shared.unRetweet(tweet: tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.retweetLabel.text = String(Int(self.retweetLabel.text!)! - 1)
                }
            })
            sender.isSelected = false
        }
        else {
            APIManager.shared.retweet(tweet: tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.retweetLabel.text = String(Int(self.retweetLabel.text!)! + 1)
                }
            })
            sender.isSelected = true
        }
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        if sender.isSelected == true {
            APIManager.shared.unfavoriteTweet(tweet: tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.likeLabel.text = String(Int(self.likeLabel.text!)! - 1)
                }
            })
            sender.isSelected = false
        }
        else {
            APIManager.shared.favoriteTweet(tweet: tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    self.likeLabel.text = String(Int(self.likeLabel.text!)! + 1)
                }
            })
            sender.isSelected = true
        }
    }
    
    func didTapProfile(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            let user = tweet?.user
            profileViewController.user = user
        }
    }

}
