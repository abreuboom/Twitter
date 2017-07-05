//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by John Abreu on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate{
    
    var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.current
        
        //profilePhotoView.af_setImage(withURL: user?.profilePhotoUrl!)
        
        tweetButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        tweetButton.layer.cornerRadius = tweetButton.frame.width / 3
        tweetButton.layer.masksToBounds = true
        
        textView.textColor = UIColor.lightGray
        
        textView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func tweet(_ sender: UIButton) {
        if(textView.text != "What's happening?" || textView.text != nil){
            let post = textView.text
            APIManager.shared.composeTweet(with: post!) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            }
            dismiss(animated: true, completion: nil)
        }
        else {
            print("No text entered")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCompose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
}
