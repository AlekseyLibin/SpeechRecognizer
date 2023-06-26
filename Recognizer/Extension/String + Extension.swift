//
//  String + Extension.swift
//  Recognizer
//
//  Created by Aleksey Libin on 25.06.2023.
//

extension String {
  /// Initialize a string with numbers from 0 to 9 or returns 'nil'
  init?(_ singleDigitInts: [SingleDigitNumber]?) {
    guard let singleDigitInts else { return nil }
    var result = ""
    singleDigitInts.forEach { result += $0.intValue }
    self.init(result)
  }
}
