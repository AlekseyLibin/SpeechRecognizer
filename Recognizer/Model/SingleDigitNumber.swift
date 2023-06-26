//
//  SingleDigitInt.swift
//  Recognizer
//
//  Created by Aleksey Libin on 25.06.2023.
//
import Foundation

enum SingleDigitNumber: String, CaseIterable {
    case zero, one, two, three, four, five, six, seven, eight, nine
  
  /// Returns a string representation of a type as a digit from 0 to 9 or empty string
  var intValue: String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.numberStyle = .spellOut
    return formatter.number(from: self.rawValue)?.intValue.description ?? ""
  }
  
}
