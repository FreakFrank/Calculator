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
    
    var description = ""
    
    private var tempOperand = ""
    
    var isPartialResult = true
    
    private var accumulator = 0.0
    
    func setOperand(operand : Double) {
        accumulator = operand
        tempOperand = String(operand)
        //description += String(operand)
    }
        
    private var operations = [
        "π"  :Operation.Constant(M_PI),
        "√"  :Operation.UnaryOperation(sqrt),
        "cos":Operation.UnaryOperation(cos),
        "sin":Operation.UnaryOperation(sin),
        "×"  : Operation.BinaryOperation({(op1 : Double, op2 : Double) -> Double in op1*op2}),
        "+"  : Operation.BinaryOperation({(op1, op2) in op1+op2}),
        "-"  : Operation.BinaryOperation({return $0-$1}),
        "÷"  : Operation.BinaryOperation({$0/$1}),
        "="  : Operation.Equals,
        "C"  : Operation.Clear,
        "X²" : Operation.UnaryOperation({pow($0,2)}),
        "X³" : Operation.UnaryOperation({pow($0,3)}),
        "∛"  : Operation.UnaryOperation({pow($0,(1/3))})
        ]
    
    
//    private var operationStrings:[Operation:String] = [  // here I was just examining wether for example Operation.UnaryOperation(sqrt):"√" AND  Operation.UnaryOperation(sin):"sin" have the same type or not and it appeared that they have
//        Operation.Constant(M_PI) :"π",
//        Operation.UnaryOperation(sqrt):"√",
//        Operation.UnaryOperation(cos):"cos",
//        Operation.UnaryOperation(sin):"sin",
//        Operation.BinaryOperation({(op1 : Double, op2 : Double) -> Double in op1*op2}):"×",
//        Operation.BinaryOperation({(op1, op2) in op1+op2}):"+",
//        Operation.BinaryOperation({return $0-$1}):"-",
//        Operation.BinaryOperation({$0/$1}):"÷",
//        Operation.Equals: "=",
//        Operation.Clear: "C",
//        Operation.UnaryOperation({return pow($0,2)}):"X²",
//        Operation.UnaryOperation({return pow($0,3)}):"X³",
//        Operation.UnaryOperation({return pow($0,(1/3))}):"∛"
//    ]
    
    
    private enum Operation : Hashable{
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        var hashValue: Int  {
        switch self {
        case .Constant : return 1
            case .UnaryOperation :return 2
            case .BinaryOperation: return 3
            case .Equals :return 4
            case .Clear :return 5
            }
        }
        static func == (lhs: Operation, rhs: Operation) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
    }
    
    func performOperation(symbol : String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value): accumulator = value
                description += tempOperand+symbol
                tempOperand = ""
            case .UnaryOperation(let function) :
                print("The cuurent value of the accumulator is \(accumulator)")
                if isPartialResult {
                    description += symbol+"("+String(accumulator)+")"
                    accumulator = function(accumulator)
                }
                else{
                    let tempDescription = description
                    description = symbol+"("+tempDescription+")"
                    accumulator = function(accumulator)
                }
                tempOperand = ""
                print("The cuurent value of the description is \(description)")

            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pendingBinaryOperation = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
                description += tempOperand+symbol
                tempOperand = ""
            case .Equals : executePendingBinaryOperation()
                isPartialResult = false
                description += tempOperand
                tempOperand = ""
            case .Clear : accumulator = 0.0
                pendingBinaryOperation = nil
                description = ""
                isPartialResult = true
                tempOperand = ""
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pendingBinaryOperation != nil{
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
