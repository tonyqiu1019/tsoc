//
//  ViewController.swift
//  Calculator
//
//  Created by Tong Qiu on 7/12/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    private var variables: [String: Double] = [:]
    
    private func updateAllDisplay() {
        let (result, isPending, description) = brain.evaluate(using: variables)
        if result != nil {
            displayValue = result!
        }
        let suffix = (description == "") ? " " : (isPending ? "..." : "=")
        descriptionLabel.text = description + suffix
        if let mValue = variables["M"] {
            memoryLabel.text = CalculatorBrain.formatted(mValue)
        } else {
            memoryLabel.text = "not set"
        }
    }
    
    var isTyping = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = CalculatorBrain.formatted(newValue)
        }
    }
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var memoryLabel: UILabel!
    
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
        updateAllDisplay()
    }
    
    @IBAction func inputVariable(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        updateAllDisplay()
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        let title = sender.currentTitle!
        let index = title.index(title.endIndex, offsetBy: -1)
        let variableName = title.substring(from: index)
        variables.updateValue(displayValue, forKey: variableName)
        isTyping = false
        updateAllDisplay()
    }
    
    @IBAction func clearScreen() {
        displayValue = 0
        descriptionLabel.text = " "
        isTyping = false
        brain.clear()
        variables.removeAll()
        memoryLabel.text = "not set"
    }
    
    @IBAction func undoOperation() {
        if isTyping {
            let displayed = display.text!
            let index = displayed.index(displayed.endIndex, offsetBy: -1)
            let deleted = displayed.substring(to: index)
            display.text = (deleted == "") ? "0" : deleted
            isTyping = (deleted != "")
        } else {
            brain.undo()
            updateAllDisplay()
        }
    }
    
}
