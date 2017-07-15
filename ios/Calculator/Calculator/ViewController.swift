//
//  ViewController.swift
//  Calculator
//
//  Created by Tong Qiu on 7/12/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTyping = false
    
    private var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = brain.formatted(newValue)
        }
    }
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isTyping {
            let displayed = display.text!
            if digit != "." || !displayed.contains(".") {
                display.text = displayed + digit
            }
        } else {
            display.text = (digit == ".") ? "0." : digit
            isTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isTyping {
            brain.setOperand(displayValue)
            isTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        var suffix = brain.resultIsPending ? "..." : "="
        if brain.description == "" {
            suffix = " "
        }
        descriptionLabel.text = brain.description + suffix
    }
    
    @IBAction func clearScreen() {
        displayValue = 0
        descriptionLabel.text = " "
        isTyping = false
        brain.clearScreen()
    }
}

