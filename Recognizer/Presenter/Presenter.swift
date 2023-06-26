//
//  Presenter.swift
//  Recognizer
//
//  Created by Aleksey Libin on 20.06.2023.
//

import Speech

final class Presenter {
  
  private weak var viewController: ViewControllerProtocol?
  private let speechRecognizer: SpeechRecognizerProtocol
  private let speechHandler: SpeechHandlerProtocol
  
  init(viewController: ViewControllerProtocol) {
    self.viewController = viewController
    self.speechRecognizer = SpeechRecognizer()
    self.speechHandler = SpeechHandler()
    requestAuthorization()
  }
  
  /// Sends a request for microphone access and speech recording
  private func requestAuthorization() {
    SFSpeechRecognizer.requestAuthorization { [weak self] status in
      switch status {
      case .notDetermined:
        print("status not determined")
      case .denied:
        print("status denied")
      case .restricted:
        print("status restricted")
      case .authorized:
        self?.startSpeechRecognition()
      @unknown default:
        print("Unknown status. Programm stops it's executing")
        fatalError()
      }
    }
  }
  
  private func startSpeechRecognition() {
    self.speechRecognizer.startSpeechRecognition { [weak self] speech in
      self?.speechHandler.process(speech: speech, completionHandler: { [ weak self] currentOperation, completedOperations in
        self?.viewController?.currentOperation(updateValue: currentOperation)
        self?.viewController?.completedOperations(updateValue: completedOperations)
      })
      self?.viewController?.currentSpeechLabel(updateValue: speech.joined(separator: " "))
    }
  }
}
