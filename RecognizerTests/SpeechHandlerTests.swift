//
//  RecognizerTests.swift
//  RecognizerTests
//
//  Created by Aleksey Libin on 20.06.2023.
//

import XCTest
@testable import Recognizer

final class SpeechHandlerTests: XCTestCase {
  
  var sut: SpeechHandler!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = SpeechHandler()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }
  
  func testProcessInput_withSingleCommand_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "code".components(separatedBy: " ")
    let expectedOperation = Operation(command: .code)
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input) { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    }
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCurrentOperation, expectedOperation, "Current operation should be correct")
    XCTAssertTrue(receivedCompletedOperations.isEmpty, "Completed operations should be empty")
  }
  
  func testProcessInput_withMultipleCommands_shouldInvokeCompletionHandlerWithCorrectOperations() {
    // Arrange
    let input = "Code 2 and 3 and 4 Count 2 Code 1 and 2 Reset Code 1 and 1 and 2 Count 5".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .count, operands: [.five])
    let expectedCompletedOperations = [
      Operation(command: .code, operands: [.two, .three, .four]),
      Operation(command: .count, operands: [.two]),
      Operation(command: .code, operands: [.one, .one, .two])
    ]
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input) { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    }
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should be correct")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "Completed operations should be correct")
  }
  
  func testProcessInput_withMultipleWrittenCommands_shouldInvokeCompletionHandlerWithCorrectOperations() {
    // Arrange
    let input = "Code Two and Three and Four Count Two Code One and Two Reset Code One and One and Two Count Five".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .count, operands: [.five])
    let expectedCompletedOperations = [
      Operation(command: .code, operands: [.two, .three, .four]),
      Operation(command: .count, operands: [.two]),
      Operation(command: .code, operands: [.one, .one, .two])
    ]
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input) { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    }
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should be correct")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "Completed operations should be correct")
  }
  
  func testProcessInput_withVariosWrittenCommands_shouldInvokeCompletionHandlerWithCorrectOperations() {
    // Arrange
    let input = "Code 2 and ThRee and FOUR Count two CODE One AND Two Reset Code 1 and One aNd Two Count FiVe".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .count, operands: [.five])
    let expectedCompletedOperations = [
      Operation(command: .code, operands: [.two, .three, .four]),
      Operation(command: .count, operands: [.two]),
      Operation(command: .code, operands: [.one, .one, .two])
    ]
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input) { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    }
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should be correct")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "Completed operations should be correct")
  }
  
  func testSpeech_withTwoDigitNumberIncorrectPassed_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "Code 42".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .code, operands: [.two])
    let expectedCompletedOperations: [Recognizer.Operation] = []
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input, completionHandler: { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    })
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "No operations should be completed")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should have a 'code' command")
  }
  
  func testSpeech_withTwoDigitNumbersIncorrectPassed_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "Code 4 2".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .code, operands: [.four])
    let expectedCompletedOperations: [Recognizer.Operation] = []
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input, completionHandler: { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    })
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "No operations should be completed")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should have a 'code' command")
  }
  
  func testSpeech_withTwoDigitNumberCorrectPassed_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "Code 4 and 2".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .code, operands: [.four, .two])
    let expectedCompletedOperations: [Recognizer.Operation] = []
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input, completionHandler: { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    })
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "No operations should be completed")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should have a 'code' command")
  }
  
  func testSpeech_withSingleCommandByWords_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "Code two".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .code, operands: [.two])
    let expectedCompletedOperations: [Recognizer.Operation] = []
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input, completionHandler: { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    })
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "No operations should be completed")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should have a 'code' command")
  }
  
  func testSpeech_withNumbersBeforeCommand_shouldInvokeCompletionHandlerWithCorrectOperation() {
    // Arrange
    let input = "Seven Eight Code two".components(separatedBy: " ")
    let expectedCurrentOperation = Operation(command: .code, operands: [.two])
    let expectedCompletedOperations: [Recognizer.Operation] = []
    var completionHandlerCalled = false
    var receivedCurrentOperation: Recognizer.Operation?
    var receivedCompletedOperations: [Recognizer.Operation] = []
    
    // Act
    sut.process(speech: input, completionHandler: { currentOperation, completedOperations in
      completionHandlerCalled = true
      receivedCurrentOperation = currentOperation
      receivedCompletedOperations = completedOperations
    })
    
    // Assert
    XCTAssertTrue(completionHandlerCalled, "Completion handler should be invoked")
    XCTAssertEqual(receivedCompletedOperations, expectedCompletedOperations, "No operations should be completed")
    XCTAssertEqual(receivedCurrentOperation, expectedCurrentOperation, "Current operation should have a 'code' command")
  }
}
