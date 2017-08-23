//
//  TweelDetailTableViewController.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/16/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    var tweet: Twitter.Tweet? { didSet { updateTweetData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deselectRows), name:
            NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = mentions[indexPath.section][indexPath.row]
        switch content {
        case .image(let img):
            return tableView.frame.width / CGFloat(img.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = mentions[indexPath.section][indexPath.row]
        switch content {
        case .image(let img):
            return constructImageCell(with: img, at: indexPath)
        case .hashtag(let mention), .userMention(let mention):
            return constructMentionCell(with: mention, at: indexPath)
        case .url(let url):
            return constructUrlCell(with: url, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let content = mentions[indexPath.section][indexPath.row]
        switch content {
        case .image(let img):
            imageToShow = img
        case .hashtag(let mention), .userMention(let mention):
            mentionToShow = mention
        case .url(let url):
            if let link = URL(string: url.keyword) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(link, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(link)
                }
            }
        }
        return indexPath
    }
    
    // MARK: - Handle all segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Search":
                if let dest = segue.destination as? TweetTableViewController {
                    dest.searchText = mentionToShow?.keyword
                    dest.searchTextField?.text = mentionToShow?.keyword
                }
            case "ShowImage":
                if let dest = segue.destination as? TweetImageViewController {
                    dest.imageUrl = imageToShow?.url
                }
            default:
                break
            }
        }
    }

    // MARK: - Private implementation
    
    private var mentionToShow: Twitter.Mention?
    private var imageToShow: Twitter.MediaItem?
    
    private enum MentionContent {
        case image(Twitter.MediaItem)
        case hashtag(Twitter.Mention)
        case userMention(Twitter.Mention)
        case url(Twitter.Mention)
    }
    
    private enum MentionIndex: Int {
        case image = 0, hashtag, userMention, url
    }
    
    private var mentions: [Array<MentionContent>] = []
    
    private var sectionTitles: [String] = []
    
    private func updateTweetData() {
        if let existingTweet = tweet {
            initializeData()
            for item in existingTweet.media {
                mentions[MentionIndex.image.rawValue].append(.image(item))
            }
            for item in existingTweet.hashtags {
                mentions[MentionIndex.hashtag.rawValue].append(.hashtag(item))
            }
            for item in existingTweet.userMentions {
                mentions[MentionIndex.userMention.rawValue].append(.userMention(item))
            }
            for item in existingTweet.urls {
                mentions[MentionIndex.url.rawValue].append(.url(item))
            }
            removeEmptySections()
            title = existingTweet.user.name
        }
    }
    
    private func initializeData() {
        mentions = [[], [], [], []]
        sectionTitles = ["Images", "Hashtags", "Users", "Links"]
    }
    
    private func removeEmptySections() {
        var index = 0
        while index < mentions.count {
            if mentions[index].isEmpty {
                mentions.remove(at: index)
                sectionTitles.remove(at: index)
            } else {
                index += 1
            }
        }
    }
    
    private func constructImageCell(with img: Twitter.MediaItem, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
        if let imageCell = cell as? ImageTableViewCell {
            imageCell.imageToDisplay = img
        }
        return cell
    }
    
    private func constructMentionCell(with mention: Twitter.Mention, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mention", for: indexPath)
        cell.textLabel?.text = mention.keyword
        return cell
    }
    
    private func constructUrlCell(with url: Twitter.Mention, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Url", for: indexPath)
        cell.textLabel?.text = url.keyword
        return cell
    }
    
    // MARK: - Application did enter background handler
    
    @objc private func deselectRows() {
        if let paths = tableView.indexPathsForSelectedRows {
            for path in paths {
                tableView.deselectRow(at: path, animated: true)
            }
        }
    }
    
}
