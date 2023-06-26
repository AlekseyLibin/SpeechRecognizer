//
//  SpeechHandler.swift
//  Recognizer
//
//  Created by Aleksey Libin on 20.06.2023.
//

import Foundation

protocol SpeechHandlerProtocol {
  func process(speech substrings: [String], completionHandler: (Operation?, [Operation]) -> Void)
}

final class SpeechHandler {
  
  private var currentOperation: Operation?
  private var completedOperations: [Operation] = []
  private var newNumberIsAllowedToAdd = true
  
}

// MARK: - SpeechHandlerProtocol
extension SpeechHandler: SpeechHandlerProtocol {
  /// Processes the user's speech input and records it as operations
  func process(speech substrings: [String], completionHandler: (Operation?, [Operation]) -> Void) {
    completedOperations = []
    currentOperation = nil
    newNumberIsAllowedToAdd = true
    for substring in substrings {
      var substring = substring.lowercased()
      var substringHasChanged = true
      
      while substringHasChanged {
        substringHasChanged = false
        for command in Command.allCases {
          if let range = substring.range(of: command.rawValue) {
            substring.removeSubrange(range)
            substringHasChanged = true
            execute(command: command)
          }
        }
        for singleDigitNumber in SingleDigitNumber.allCases {
          if let range = substring.range(of: singleDigitNumber.rawValue) ??
              substring.range(of: singleDigitNumber.intValue) {
            substring.removeSubrange(range)
            substringHasChanged = true
            addNumber(singleDigitNumber)
          }
        }
      }
      completionHandler(currentOperation, completedOperations)
    }
  }
}

// MARK: - Business logic
private extension SpeechHandler {
  /// Performs certain actions depending on the given command
  func execute(command: Command) {
    newNumberIsAllowedToAdd = true
    switch command {
    case .code:
      completeCurrentOperation()
      currentOperation = Operation(command: .code)
    case .count:
      completeCurrentOperation()
      currentOperation = Operation(command: .count)
    case .reset:
      resetCurrentOperation()
    case .back:
      eraseOperation()
    case .and:
      newNumberIsAllowedToAdd = true
    }
  }
  
  /// Adds a number to the current operation if it exists
  func addNumber(_ number: SingleDigitNumber) {
    if currentOperation != nil,
       newNumberIsAllowedToAdd {
      currentOperation?.operands.append(number)
      newNumberIsAllowedToAdd = false
    }
  }
  
  /// Completes the current operation
  func completeCurrentOperation() {
    if let operation = currentOperation,
       !operation.operands.isEmpty,
       completedOperations.last != operation {
      completedOperations.append(operation)
    }
    currentOperation = nil
  }
  
  /// Executes the command "Reset"
  func resetCurrentOperation() {
    currentOperation = nil
  }
  
  /// Executes the command "Back"
  func eraseOperation() {
    resetCurrentOperation()
    if completedOperations.count != 0 {
      completedOperations.removeLast()
    }
  }
}
