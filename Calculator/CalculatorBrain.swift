//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kareem Ismail on 12/15/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

import Foundation


class CalculatorBrain{
    
    private var pendingBinaryOperation : PendingBinaryOperationInfo?
    
    private var accumulator = 0.0
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    private var operations = [
        "π" :Operation.Constant(M_PI),
        "e" :Operation.Constant(M_E),
        "√" :Operation.UnaryOperation(sqrt),
        "cos" :Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({(op1 : Double, op2 : Double) -> Double in op1*op2}),
        "+" : Operation.BinaryOperation({(op1, op2) in op1+op2}),
        "-" : Operation.BinaryOperation({return $0-$1}),
        "÷" : Operation.BinaryOperation({$0/$1}),
        "=" : Operation.Equals,
        "C" : Operation.Clear
        ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    func performOperation(symbol : String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value): accumulator = value
            print("Im in constant")
            case .UnaryOperation(let function) : accumulator = function(accumulator)
            case .BinaryOperation(let function):
                print("Value of accumulator is \(accumulator)")
                executePendingBinaryOperation()
                pendingBinaryOperation = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
                print("Im in binary")
            case .Equals : executePendingBinaryOperation()
                           print("Im in equals")
            case .Clear : accumulator = 0.0; pendingBinaryOperation = nil
            print("Im in clear")
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pendingBinaryOperation != nil{
            print("Value of first operand is \(pendingBinaryOperation!.firstOperand)")
            accumulator = pendingBinaryOperation!.binaryOperation(pendingBinaryOperation!.firstOperand, accumulator)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation : (Double, Double) -> Double
        var firstOperand : (Double)
    }
    
    var result : Double {
        get {return accumulator}
    }
}
