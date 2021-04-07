//
//  MockCombineHelper.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/6/21.
//

import Foundation
import Combine

struct MockCombineHelper: CombineHelperProtocol {
  var completionArray: [String]
  
  init(completionArray: [String] = ["4493","321988","36567"]) {
    self.completionArray = completionArray
  }
  
  func createIDRequest(fromURL: URL) -> AnyPublisher<String, Never> {
    Just("36437")
      .eraseToAnyPublisher()
  }
  
  mutating func mergeRequests(_ requests: [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void) {
    completion(completionArray)
  }
}

