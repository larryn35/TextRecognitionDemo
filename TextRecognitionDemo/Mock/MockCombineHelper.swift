//
//  MockCombineHelper.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/6/21.
//

import Foundation
import Combine

struct MockCombineHelper: CombineHelperProtocol {
  var idErrors: [String] = []
  
  var completionArray: [String]
  
  init(completionArray: [String] = ["4493","321988","36567"]) {
    self.completionArray = completionArray
  }
  
  mutating func mergeRequests(_ requests: [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void) {
    completion(completionArray)
  }
}

