//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by John Abreu on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundPhotoView: UIImageView!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var screenNameField: UILabel!
    @IBOutlet weak var captionField: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    
    var user = User.current
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        profilePhotoView.layer.borderWidth = 3
        profilePhotoView.layer.borderColor = UIColor.white.cgColor
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width / 2
        profilePhotoView.layer.masksToBounds = true
        profilePhotoView.layer.zPosition = 20
        
        setUserData()
        getTimeline()
    }
    
    func setUserData () {
        if let backgroundPhotoURL = user?.backgroundPhotoUrl {
            backgroundPhotoView.af_setImage(withURL: backgroundPhotoURL)
        }
        else {
            backgroundPhotoView.backgroundColor = UIColor.white
        }
        let profURL = user?.profilePhotoUrl?.absoluteString
        let updatedURL = profURL?.replacingOccurrences(of: "_bigger", with: "")
        let profilePhotoURL = URL(string: updatedURL!)
        profilePhotoView.af_setImage(withURL: profilePhotoURL!)
        nameField.text = user?.name
        let screenName = user?.screenName
        screenNameField.text = "@" + screenName!
        captionField.text = user?.description
        followingLabel.text = user?.intFormatter(x: user?.following! ?? 0)
        followersLabel.text = user?.intFormatter(x:user?.followers! ?? 0)
    }
    
    func getTimeline() {
        let screenName = user?.screenName
        APIManager.shared.getUserTimeLine(screenName: screenName!) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getTimeline()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func composeTweet(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "composeSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath =  tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.tweet = tweet
            }
        }
    }

}
