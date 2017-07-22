//
//  SplitViewController.swift
//  Calculator
//
//  Created by Tong Qiu on 7/21/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .automatic
    }

    func splitViewController(_ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool { return true }
    
}
