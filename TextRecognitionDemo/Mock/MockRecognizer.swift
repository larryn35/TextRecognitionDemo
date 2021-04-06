//
//  MockRecognizer.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import UIKit

struct MockRecognizer: RecognizerServiceProtocol {
  var completeWithFailure: Bool
  var rawText: [String]
  
  init(completeWithFailure: Bool = false, rawText: [String] = MockData.rawTextFromRecognizer) {
    self.completeWithFailure = completeWithFailure
    self.rawText = rawText
  }
  
  func scanText(from image: UIImage, completion: @escaping (Result<[String], RecognizerError>) -> Void) {
    if completeWithFailure {
      completion(.failure(.error("Failed to process image")))
    } else {
      completion(.success(rawText))
    }
  }
}
