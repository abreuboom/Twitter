//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate,  ComposeViewControllerDelegate, TweetCellDelegate {
    
    var tweets: [Tweet] = []
    
    var tappedUser: User?
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
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
        
        loadingMoreView = InfiniteScrollActivityView(frame: tableView.frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
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
    
    func loadMoreTweets() {
        let lastTweet = tweets[tweets.count - 1]
        APIManager.shared.getMoreTweets(tweet: lastTweet) { (tweets, error) in
            if let tweets = tweets {
                //tweets.remove(at: 0)
                self.tweets = self.tweets + tweets
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            } else if let error = error {
                print("Error getting new tweets: " + error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreTweets()
            }
        }
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
        
        cell.replyButton.tag = indexPath.row
        
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
    
    @IBAction func replyTweet(_ sender: UIButton) {
        let tweet = tweets[sender.tag]
        performSegue(withIdentifier: "detailSegue", sender: tweet)
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
            if sender is UITableViewCell {
                let cell = sender as! UITableViewCell
                if let indexPath =  tableView.indexPath(for: cell) {
                    let tweet = tweets[indexPath.row]
                    let detailViewController = segue.destination as! DetailViewController
                    detailViewController.tweet = tweet
                }
            }
            else if sender is Tweet {
                let tweet = sender as! Tweet
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.tweet = tweet
            }
        }
    }
    
}
