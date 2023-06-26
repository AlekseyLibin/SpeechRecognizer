//
//  ViewController.swift
//  Recognizer
//
//  Created by Aleksey Libin on 20.06.2023.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
  func currentSpeechLabel(updateValue value: String)
  func completedOperations(updateValue operation: [Operation])
  func currentOperation(updateValue operation: Operation?)
}

final class ViewController: UIViewController {
  
  private let currentSpeechLabel = UILabel()
  private let valuesLabel = UILabel()
  private let currentStatusView = OperationView()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private var completedOperations: [Operation] = []
  private var presenter: Presenter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = Presenter(viewController: self)
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    
    currentStatusView.layer.cornerRadius = 5
    currentStatusView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(currentStatusView)
    
    let currentSpeechLabelTitle = UILabel()
    currentSpeechLabelTitle.text = "Current Speech"
    currentSpeechLabelTitle.font = .boldSystemFont(ofSize: 24)
    currentSpeechLabelTitle.textAlignment = .center
    
    currentSpeechLabel.text = "Waiting for speech ..."
    currentSpeechLabel.textAlignment = .center
    currentSpeechLabel.numberOfLines = 1
    currentSpeechLabel.font = .systemFont(ofSize: 24)
    currentSpeechLabel.lineBreakMode = .byTruncatingHead
    
    let speechStack = UIStackView(arrangedSubviews: [currentSpeechLabelTitle, currentSpeechLabel])
    speechStack.axis = .vertical
    speechStack.backgroundColor = UIColor(red: 149/255, green: 192/255, blue: 221/255, alpha: 1)
    speechStack.distribution = .fillEqually
    speechStack.layer.cornerRadius = 5
    speechStack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(speechStack)
    
    valuesLabel.text = "Values"
    valuesLabel.font = .systemFont(ofSize: 32)
    valuesLabel.textColor = .black
    valuesLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(valuesLabel)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CompletedOperationCell.self, forCellWithReuseIdentifier: "CompletedOperationCell")
    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      currentStatusView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      currentStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      currentStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      currentStatusView.heightAnchor.constraint(equalToConstant: 110),
      
      speechStack.topAnchor.constraint(equalTo: currentStatusView.bottomAnchor, constant: 10),
      speechStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      speechStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      speechStack.heightAnchor.constraint(equalToConstant: 80),
      
      valuesLabel.topAnchor.constraint(equalTo: speechStack.bottomAnchor, constant: 30),
      valuesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      collectionView.topAnchor.constraint(equalTo: valuesLabel.bottomAnchor, constant: 30),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
    ])
  }
}

// MARK: ViewControllerProtocol
extension ViewController: ViewControllerProtocol {
  /// Updates value for current operation
  func currentOperation(updateValue operation: Operation?) {
    if let operation = operation {
      currentStatusView.updateStatus(to: .listening, for: operation)
    } else {
      currentStatusView.updateStatus(to: .waiting)
    }
  }
  
  /// Updates value for completed operations array
  func completedOperations(updateValue operations: [Operation]) {
    completedOperations = operations
    valuesLabel.isHidden = operations.isEmpty
    collectionView.reloadData()
  }
  
  /// Updates value for label, that represents current speech to user
  func currentSpeechLabel(updateValue value: String) {
    currentSpeechLabel.text = value
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return completedOperations.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let completedOperationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedOperationCell", for: indexPath) as? CompletedOperationCell  else { return UICollectionViewCell() }
    completedOperationCell.setOperation(completedOperations[indexPath.row])
    return completedOperationCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}
