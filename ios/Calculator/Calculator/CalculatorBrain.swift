//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tong Qiu on 7/13/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: (value: Double, history: String)?
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
    }
    
    private var operators: Dictionary<String, Operation> = [
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
    
    private struct pendingBinaryOperation {
        let op1: (value: Double, history: String)
        let function: (Double, Double) -> Double
        let symbol: String
        
        func perform(with op2: (value: Double, history: String)) -> (value: Double, history: String) {
            return (function(op1.value, op2.value), "\(op1.history) \(symbol) \(op2.history)")
        }
    }
    
    private var pdo: pendingBinaryOperation?
    
    private mutating func performPendingBinaryOperation() {
        if accumulator != nil && pdo != nil {
            accumulator = pdo!.perform(with: accumulator!)
            pdo = nil
        }
    }
    
    var result: Double? {
        get {
            return accumulator?.value
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pdo != nil
        }
    }
    
    var description: String {
        get {
            var ret = (accumulator != nil) ? "\(accumulator!.history) " : ""
            if pdo != nil {
                ret = "\(pdo!.op1.history) \(pdo!.symbol) \(ret)"
            }
            return ret
        }
    }
    
    func formatted(_ value: Double) -> String {
        return fabs(Double(Int(value)) - value) < 1e-6 ? String(Int(value)) : String(value)
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operators[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
            case .unary(let function):
                let prepend = symbol == "±" ? "-" : symbol
                if accumulator != nil {
                    accumulator = (function(accumulator!.value), "\(prepend)(\(accumulator!.history))")
                }
            case .binary(let function):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pdo = pendingBinaryOperation(op1: accumulator!, function: function, symbol: symbol)
                    accumulator = nil
                }
            case .equal:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, formatted(operand))
    }
    
    mutating func clearScreen() {
        accumulator = nil
        pdo = nil
    }
    
}
