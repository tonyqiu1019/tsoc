//
//  GraphViewController.swift
//  Calculator
//
//  Created by Tong Qiu on 7/20/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDelegate {
    
    var function: ((Double) -> Double?)?
    
    var functionLabelText: String?
    
    @IBOutlet weak var functionName: UILabel!
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let pinchHandler = #selector(GraphView.changeScale(byReactingTo: ))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: pinchHandler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let panHandler = #selector(GraphView.moveAxes(byReactingTo: ))
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: panHandler)
            graphView.addGestureRecognizer(panRecognizer)
            
            let tapHandler = #selector(GraphView.setOrigin(byReactingTo: ))
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: tapHandler)
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    override func viewDidLoad() {
        graphView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let text = functionLabelText, text != "" {
            let replacedText = text.replacingOccurrences(of: "M", with: "x")
            functionName.text = "y = \(replacedText)"
        } else {
            functionName.text = " "
        }
    }
    
    func getYCoordinate(using x: Double) -> Double? {
        if let result = function?(x) {
            return result.isNaN ? nil : result
        }
        return nil
    }
    
}
