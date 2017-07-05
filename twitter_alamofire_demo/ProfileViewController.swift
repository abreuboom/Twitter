//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by John Abreu on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var screenNameField: UILabel!
    @IBOutlet weak var captionField: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    
    
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
        let screename = User.current?.screenName
        APIManager.shared.getUserTimeLine(screenName: screename!) { (tweets, error) in
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
