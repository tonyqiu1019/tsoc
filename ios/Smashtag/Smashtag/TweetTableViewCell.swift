//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/16/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    // MARK: - Private implementation
    
    private final let hashtagColor = UIColor.blue
    private final let userMentionColor = UIColor.orange
    private final let urlColor = UIColor.brown
    
    private func updateUI() {
        if let existingTweet = tweet {
            let colorString = NSMutableAttributedString(string: existingTweet.text)
            for hashtag in existingTweet.hashtags {
                colorString.addAttribute(NSForegroundColorAttributeName, value: hashtagColor, range: hashtag.nsrange)
            }
            for userMention in existingTweet.userMentions {
                colorString.addAttribute(NSForegroundColorAttributeName, value: userMentionColor, range: userMention.nsrange)
            }
            for url in existingTweet.urls {
                colorString.addAttribute(NSForegroundColorAttributeName, value: urlColor, range: url.nsrange)
            }
            tweetTextLabel?.attributedText = colorString
        }
        
        tweetUserLabel?.text = tweet?.user.description
        
        if let url = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.tweet?.user.profileImageURL {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
}
