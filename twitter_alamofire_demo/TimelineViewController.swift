//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,  ComposeViewControllerDelegate, TweetCellDelegate {
    
    var tweets: [Tweet] = []
    
    var tappedUser: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
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
        getTimeline()
        
    }
    
    func getTimeline() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
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
        
        cell.profilePhotoView.tag = indexPath.row
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimelineViewController.didTapProfile(_:)))
        tapped.numberOfTapsRequired = 1
        cell.profilePhotoView?.addGestureRecognizer(tapped)
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    @IBAction func composeTweet(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "composeSegue", sender: self)
    }
    
    func did(post: Tweet) {
        tweets.insert(post, at: 0)
        tableView.reloadData()
    }
    
    func didTapProfile(_ sender: UITapGestureRecognizer) {
        let indexPathRow = sender.view?.tag
        let tweet = tweets[indexPathRow!]
        tappedUser = tweet.user
        if tappedUser != nil {
            performSegue(withIdentifier: "profileSegue", sender: nil)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.delegate = self
        }
        else if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = tappedUser!
        }
        else if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath =  tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.tweet = tweet
            }
        }
    }
    
}
