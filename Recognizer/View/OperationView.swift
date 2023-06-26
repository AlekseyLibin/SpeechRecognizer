//
//  StatusView.swift
//  Recognizer
//
//  Created by Aleksey Libin on 20.06.2023.
//

import UIKit

protocol OperationViewProtocol {
  func updateStatus(to newStatus: OperationView.OperationStatus, for updatedOperation: Operation?)
}

final class OperationView: UIView {
  enum OperationStatus: String {
    case waiting, listening
  }
  
  private var operation: Operation?
  private var status: OperationStatus
  
  init(for operation: Operation? = nil, status: OperationStatus = .waiting) {
    self.operation = operation
    self.status = status
    super.init(frame: .zero)
    setupViews(with: status)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews(with status: OperationStatus) {
    removeSubviews()
    switch status {
    case .waiting:
      waitingStateView()
    case .listening:
      listeningStateView()
    }
  }
  
  private func removeSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
  
  private func waitingStateView() {
    backgroundColor = UIColor(red: 146/255, green: 204/255, blue: 169/255, alpha: 1)
    let waitingLabel = UILabel()
    waitingLabel.text = "Waiting for commands..."
    waitingLabel.textAlignment = .center
    waitingLabel.font = .systemFont(ofSize: 27)
    waitingLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(waitingLabel)
    
    NSLayoutConstraint.activate([
      waitingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      waitingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      waitingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      waitingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
  
  private func listeningStateView() {
    backgroundColor = UIColor(red: 146/255, green: 204/255, blue: 169/255, alpha: 1)
    let currentStatusLabel = UILabel()
    currentStatusLabel.text = "Current Status"
    currentStatusLabel.font = .boldSystemFont(ofSize: 24)
    currentStatusLabel.textAlignment = .center
    
    let statusLabel = UILabel()
    statusLabel.text = "Status: \(operation?.command.rawValue.capitalized ?? "")"
    statusLabel.font = .systemFont(ofSize: 22)
    
    let parametersLabel = UILabel()
    parametersLabel.text = "Parameters: \(String(operation?.operands) ?? "")"
    parametersLabel.font = .systemFont(ofSize: 22)
    
    let stackView = UIStackView(arrangedSubviews: [currentStatusLabel, statusLabel, parametersLabel])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}

// MARK: - OperationViewProtocol
extension OperationView: OperationViewProtocol {
  /// Updates operation status and its representation
  func updateStatus(to newStatus: OperationStatus, for updatedOperation: Operation? = nil) {
    operation = updatedOperation
    status = newStatus
    setupViews(with: newStatus)
  }
}
