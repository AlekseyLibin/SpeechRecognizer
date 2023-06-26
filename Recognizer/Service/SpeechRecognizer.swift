//
//  SpeechRecognizer.swift
//  Recognizer
//
//  Created by Aleksey Libin on 20.06.2023.
//

import Speech

protocol SpeechRecognizerProtocol {
  func startSpeechRecognition(completionHandler: @escaping ([String]) -> Void)
}

final class SpeechRecognizer {
  
  private let audioEngine: AVAudioEngine
  private let speechRecognizer: SFSpeechRecognizer?
  private var request:  SFSpeechAudioBufferRecognitionRequest
  private var recognitionTask: SFSpeechRecognitionTask?
  private var contextualKeywords: [String]?
  
  init(request: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest(),
       recognitionTask: SFSpeechRecognitionTask? = nil,
       audioEngine: AVAudioEngine = AVAudioEngine(),
       speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en_US")),
       contextualKeywords: [String]? = nil
  ) {
    self.audioEngine = audioEngine
    self.speechRecognizer = speechRecognizer
    self.request = request
    self.recognitionTask = recognitionTask
    self.contextualKeywords = contextualKeywords ?? setContextualKeywords(by: Command.allCases, numbersRange: 0...9)
  }
}

// MARK: - SpeechRecognizerProtocol
extension SpeechRecognizer: SpeechRecognizerProtocol {
  /// Starts speech recognition
  func startSpeechRecognition(completionHandler: @escaping ([String]) -> Void) {
    let node = audioEngine.inputNode
    let recognitionFormat = node.outputFormat(forBus: 0)
    
    node.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) { [weak self] buffer, audioTime in
      self?.request.append(buffer)
    }
    
    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch {
      print(error.localizedDescription)
      return
    }
    
    request.contextualStrings = contextualKeywords ?? []
    request.taskHint = .confirmation
    speechRecognizer?.defaultTaskHint = .confirmation
    
    recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
      if let result = result {
        completionHandler(result.bestTranscription.formattedString.components(separatedBy: " "))
        result.isFinal ? node.removeTap(onBus: 0) : ()
      } else {
        print(error?.localizedDescription ?? "")
      }
    }
  }
}

private extension SpeechRecognizer {
  /// Sets hint words array for the speech recognizer to prepare the system for specific commands
  func setContextualKeywords(by commands: [Command], numbersRange: ClosedRange<Int>) -> [String] {
    var strings = [String]()
    commands.forEach {
      strings.append($0.rawValue)
      strings.append($0.rawValue.capitalized)
    }
    Array(numbersRange).forEach {
      strings.append($0.description)
      strings.append(wordRepresentation(of: $0))
      strings.append(wordRepresentation(of: $0).capitalized)
    }
    return strings
  }
  
  /// Returns the name of a number in a given language.
  func wordRepresentation(of number: Int, locale: Locale = Locale(identifier: "en_US")) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .spellOut
    guard let numberString = numberFormatter.string(from: NSNumber(value: number)) else {
      return ""
    }
    return numberString
  }
}
