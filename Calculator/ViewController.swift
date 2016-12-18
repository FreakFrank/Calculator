//
//  ViewController.swift
//  Calculator
//
//  Created by Kareem Ismail on 12/13/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var sequenceOfOperations: UILabel!
    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false
    private var alreadyTypedPeriod = false
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTyping){
            let textCurrentlyInDisplay = display.text!
            if(digit == "." && !textCurrentlyInDisplay.contains(".") || digit != "."){
                display.text = textCurrentlyInDisplay + digit
            }
        }
        else{
            if(digit != "."){
                display.text =  digit
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var  displayValue : Double { //computed property
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            brain.isPartialResult = true
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        if brain.isPartialResult{
            sequenceOfOperations.text = brain.description+" ..."
        }
        else{
            sequenceOfOperations.text = brain.description+" ="
        }
    }
}



