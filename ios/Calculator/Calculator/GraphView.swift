//
//  GraphView.swift
//  Calculator
//
//  Created by Tong Qiu on 7/20/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

protocol GraphViewDelegate: class {
    func getYCoordinate(using x: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    private var boundsCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func drawGraph() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: origin ?? boundsCenter)
        var isContinuous = false
        
        for xCoordinate in stride(from: bounds.minX, to: bounds.maxX, by: 1) {
            let xValue = Double((xCoordinate - (origin ?? boundsCenter).x) / scale)
            if let yValue = delegate?.getYCoordinate(using: xValue) {
                let yCoordinate = (origin ?? boundsCenter).y - CGFloat(yValue) * scale
                if fabs(path.currentPoint.y - yCoordinate) > bounds.height {
                    isContinuous = false
                }
                if isContinuous {
                    path.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
                } else {
                    path.move(to: CGPoint(x: xCoordinate, y: yCoordinate))
                    isContinuous = true
                }
            } else {
                isContinuous = false
            }
        }
        
        path.lineWidth = lineWidth
        return path
    }
    
    weak var delegate: GraphViewDelegate?
    
    @IBInspectable
    var colorAxes: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var colorCurve: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func moveAxes(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed, .ended:
            let pt1 = origin ?? boundsCenter
            let pt2 = panRecognizer.translation(in: self)
            origin = CGPoint(x: pt1.x + pt2.x, y: pt1.y + pt2.y)
            panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
        default:
            break
        }
    }
    
    func setOrigin(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        origin = tapRecognizer.location(in: self)
    }

    override func draw(_ rect: CGRect) {
        let axesDrawer = AxesDrawer(color: colorAxes, contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxes(in: bounds, origin: origin ?? boundsCenter, pointsPerUnit: scale)
        
        colorCurve.set()
        drawGraph().stroke()
    }
    
}
