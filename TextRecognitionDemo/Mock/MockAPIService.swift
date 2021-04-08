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
  let interactionsJSON: String
  
  init(getJSONCompletedWithFailure: Bool = false,
       interactionsJSON: String = MockData.interactionsJSON) {
    self.getJSONCompletedWithFailure = getJSONCompletedWithFailure
    self.interactionsJSON = interactionsJSON
  }
  
  func getJSON<T>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
    if getJSONCompletedWithFailure {
      completion(.failure(.error("Failed to get JSON")))
    } else {
      let mockInteractionsJSON = interactionsJSON.data(using: .utf8)!
      let interactionsContainer = try? JSONDecoder().decode(InteractionsContainer.self, from: mockInteractionsJSON)
      completion(.success(interactionsContainer as! T))
    }
  }
}
