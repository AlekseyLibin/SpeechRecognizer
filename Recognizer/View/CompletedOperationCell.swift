//
//  CompletedOperationCell.swift
//  Recognizer
//
//  Created by Aleksey Libin on 25.06.2023.
//

import UIKit

final class CompletedOperationCell: UICollectionViewCell {
  
  private var operation: Operation?
  
  func setOperation(_ operation: Operation) {
    self.operation = operation
    setupViews()
  }
  
  private func setupViews() {
    backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 218/255, alpha: 1)
    layer.cornerRadius = 5
    
    subviews.forEach { $0.removeFromSuperview() }
    
    let commandLabel = UILabel()
    commandLabel.text = "Command: \(operation?.command.rawValue.capitalized ?? "")"
    commandLabel.font = .systemFont(ofSize: 22)
    
    let valueLabel = UILabel()
    valueLabel.text = "Value: \(String(operation?.operands) ?? "")"
    valueLabel.font = .systemFont(ofSize: 22)
    
    let stackView = UIStackView(arrangedSubviews: [commandLabel, valueLabel])
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
