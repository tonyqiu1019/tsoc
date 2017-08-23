//
//  TweetTableTableViewController.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/16/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var searchText: String? {
        didSet {
            if let existingSearchText = searchText {
                RecentSearch.instance.addSearchItem(named: existingSearchText)
            }
            title = searchText
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            
            lastTwitterRequest = nil // for refresh
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if title == nil || title == "" {
            title = "Smash Tag"
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        selectedTweet = tweet
        return indexPath
    }
    
    // MARK: - Show tweet segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowTweet",
            let source = segue.source as? TweetTableViewController,
            let dest = segue.destination as? TweetDetailTableViewController
        {
            dest.tweet = source.selectedTweet
        }
    }
    
    // MARK: - Private implementation
    
    private var tweets = [Array<Twitter.Tweet>]()
    
    private var selectedTweet: Tweet?
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func makeTwitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? makeTwitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if self?.lastTwitterRequest == request {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing() // for refresh
                }
            }
        } else {
            refreshControl?.endRefreshing() // for refresh
        }
    }

}
