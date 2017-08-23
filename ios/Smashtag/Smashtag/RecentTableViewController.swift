//
//  RecentTableViewController.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/18/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class RecentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent Searches"
        tableView.allowsMultipleSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearch.instance.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearch", for: indexPath)
        cell.textLabel?.text = RecentSearch.instance.items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        keyword = RecentSearch.instance.items[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            RecentSearch.instance.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "Search" {
            if let dest = segue.destination as? TweetTableViewController {
                dest.searchText = keyword
                dest.searchTextField?.text = keyword
            }
        }
    }
    
    // MARK: - Private implementation
    
    private var keyword: String?
    
    @objc private func saveSearches() {
        RecentSearch.instance.synchronize()
    }

}
