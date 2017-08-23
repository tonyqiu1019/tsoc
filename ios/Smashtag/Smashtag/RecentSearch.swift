//
//  RecentSearch.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/18/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import Foundation

struct RecentSearch {
    
    static var instance = RecentSearch(count: 100)
    
    init(count n: Int) {
        maxCount = n
        if var arr = UserDefaults.standard.stringArray(forKey: "search") {
            while arr.count > maxCount {
                arr.removeLast()
            }
            searchItems = arr
            for str in arr {
                duplicates.insert(str.lowercased())
                lowerCased.append(str.lowercased())
            }
        }
    }
    
    mutating func addSearchItem(named str: String) {
        if !duplicates.contains(str.lowercased()) {
            searchItems.insert(str, at: 0)
            lowerCased.insert(str.lowercased(), at: 0)
            duplicates.insert(str.lowercased())

            if searchItems.count > maxCount {
                searchItems.removeLast()
                lowerCased.removeLast()
            }
        } else {
            if let indexToRemove = lowerCased.index(of: str.lowercased()) {
                searchItems.remove(at: indexToRemove)
                lowerCased.remove(at: indexToRemove)
                searchItems.insert(str, at: 0)
                lowerCased.insert(str.lowercased(), at: 0)
            }
        }
    }
    
    mutating func deleteItem(at index: Int) {
        if 0 <= index, index < searchItems.count {
            searchItems.remove(at: index)
            let removeStr = lowerCased.remove(at: index)
            duplicates.remove(removeStr)
        }
    }
    
    mutating func deleteItem(using key: String) {
        if let indexToRemove = lowerCased.index(of: key.lowercased()) {
            searchItems.remove(at: indexToRemove)
            lowerCased.remove(at: indexToRemove)
            duplicates.remove(key.lowercased())
        }
    }
    
    func synchronize() {
        UserDefaults.standard.set(searchItems, forKey: "search")
    }
    
    var items: [String] { get { return searchItems } }

    private var maxCount: Int = 0
    
    private var searchItems: [String] = []
    
    private var lowerCased: [String] = []
    
    private var duplicates: Set<String> = []
    
}
