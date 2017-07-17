//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tong Qiu on 7/13/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
    }
    
    private var operators: [String: Operation] = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unary(sqrt),
        "±" : Operation.unary({ -$0 }),
        "sin" : Operation.unary(sin),
        "cos" : Operation.unary(cos),
        "tan" : Operation.unary(tan),
        "ln" : Operation.unary({ log2($0) / log2(M_E) }),
        "+" : Operation.binary({ $0 + $1 }),
        "-" : Operation.binary({ $0 - $1 }),
        "×" : Operation.binary({ $0 * $1 }),
        "÷" : Operation.binary({ $0 / $1 }),
        "=" : Operation.equal,
        ]
    
    private enum Action {
        case operand(Double)
        case operation(String)
        case variable(String)
    }
    
    private var actions: [Action] = []
    
    private struct pendingBinaryOperation {
        let op1: (value: Double, history: String)
        let function: (Double, Double) -> Double
        let symbol: String
        
        func perform(with op2: (value: Double, history: String)) -> (value: Double, history: String) {
            return (function(op1.value, op2.value), "\(op1.history) \(symbol) \(op2.history)")
        }
    }
    
    var result: Double? {
        get {
            return evaluate().result
            
        }
    }
    
    var resultIsPending: Bool {
        get {
            return evaluate().isPending
        }
    }
    
    var description: String {
        get {
            return evaluate().description
        }
    }
    
    static func formatted(_ value: Double) -> String {
        return (fabs(Double(Int(value)) - value) < 1e-6) ? String(Int(value)) : String(value)
    }
    
    mutating func performOperation(_ symbol: String) {
        actions.append(Action.operation(symbol))
    }
    
    mutating func setOperand(_ operand: Double) {
        actions.append(Action.operand(operand))
    }
    
    mutating func setOperand(variable named: String) {
        actions.append(Action.variable(named))
    }
    
    func evaluate(using variables: [String: Double]? = nil) -> (result: Double?, isPending: Bool, description: String) {
        var accumulator: (value: Double, history: String)?
        var pbo: pendingBinaryOperation?
        
        func performPendingBinaryOperation() {
            if accumulator != nil && pbo != nil {
                accumulator = pbo!.perform(with: accumulator!)
                pbo = nil
            }
        }
        
        for action: Action in actions {
            switch action {
            case .operand(let value):
                accumulator = (value, CalculatorBrain.formatted(value))
                
            case .operation(let symbol):
                if let operation = operators[symbol] {
                    switch operation {
                    case .constant(let value):
                        accumulator = (value, symbol)
                    case .unary(let function):
                        let prepend = (symbol == "±") ? "-" : symbol
                        if accumulator != nil {
                            accumulator = (function(accumulator!.value), "\(prepend)(\(accumulator!.history))")
                        }
                    case .binary(let function):
                        performPendingBinaryOperation()
                        if accumulator != nil {
                            pbo = pendingBinaryOperation(op1: accumulator!, function: function, symbol: symbol)
                            accumulator = nil
                        }
                    case .equal:
                        performPendingBinaryOperation()
                    }
                }
                
            case .variable(let variableName):
                if let variableValue = variables?[variableName] {
                    accumulator = (variableValue, variableName)
                } else {
                    accumulator = (0, variableName)
                }
            }
        }
        
        var retDescription = (accumulator != nil) ? "\(accumulator!.history) " : ""
        if pbo != nil {
            retDescription = "\(pbo!.op1.history) \(pbo!.symbol) \(retDescription)"
        }

        return (accumulator?.value, (pbo != nil), retDescription)
    }
    
    mutating func clear() {
        actions.removeAll()
    }
    
    mutating func undo() {
        if actions.count > 0 {
            actions.removeLast()
        }
    }
    
}
