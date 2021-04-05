//
//  String+DataScrubing.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

extension String {
  /// Removes any non-letter characters from string
  /// - Returns: String containing only characters
  func returnOnlyLetters() -> String {
    let acceptedChars = Set("abcdefghijklmnopqrstuvwxyz")
    return self.lowercased().filter { acceptedChars.contains($0) }
  }
  
  /// Returns Bool indicating if string starts with inputted `string`, similar to default `starts(with:)` method, but regardless of case
  /// - Parameter string: String representing possible prefix for string
  /// - Returns: Bool depending if match is made
  func startsWith(_ string: String) -> Bool {
    return self.range(of: "^\(string)", options: [.caseInsensitive, .regularExpression]) != nil
  }
}

