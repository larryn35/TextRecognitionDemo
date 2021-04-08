//
//  HelperFunctions.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/6/21.
//

import Foundation
import Combine

final class CombineHelper: CombineHelperProtocol {
  private var cancellables = Set<AnyCancellable>()
  
  func mergeRequests(_ requests:  [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void) {
    Publishers.MergeMany(requests)
      .filter { $0 != "" }
      .collect()
      .sink { _ in
      } receiveValue: { ids in
        completion(ids)
      }
      .store(in: &cancellables)
  }
}

protocol CombineHelperProtocol {
  mutating func mergeRequests(_ requests:  [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void)
}
