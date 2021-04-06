//
//  MockAPIService.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation
import Combine

final class MockAPIService: APIServiceProtocol {
  let getJSONCompletedWithFailure: Bool
  let mergeRequestCompleteWithFailure: Bool
  
  init(getJSONCompletedWithFailure: Bool = false, mergeRequestCompleteWithFailure: Bool = false) {
    self.getJSONCompletedWithFailure = getJSONCompletedWithFailure
    self.mergeRequestCompleteWithFailure = mergeRequestCompleteWithFailure
  }
  
  func getJSON<T>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
    if getJSONCompletedWithFailure {
      completion(.failure(.error("Failed to get JSON")))
    } else {
      let mockInteractionsJSON = MockData.interactionsJSON.data(using: .utf8)!
      let interactionsContainer = try? JSONDecoder().decode(InteractionsContainer.self, from: mockInteractionsJSON)
      completion(.success(interactionsContainer as! T))

    }
  }
  
  func createIDRequest(url: URL) -> AnyPublisher<String, Never> {
    Just("36437")
      .eraseToAnyPublisher()
  }
  
  func mergeRequests(_ requests: [AnyPublisher<String, Never>], completion: @escaping (Result<[String], APIError>) -> Void) {
    if mergeRequestCompleteWithFailure {
      completion(.failure(.error("Failed to merge requests")))
    } else {
      completion(.success([
        "4493",
        "321988",
        "36567"
      ]))
    }
  }
  
  
}
