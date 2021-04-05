//
//  APIService.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import Foundation
import Combine

final class APIService: APIServiceProtocol {
  var cancellables = Set<AnyCancellable>()

  func getJSON<T: Decodable>(url: URL, completion: @escaping (Result<T,APIError>) -> Void) {

    let request = URLRequest(url: url)

    URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink { taskCompletion in
        switch taskCompletion {
        case .finished:
          return
        case .failure(let decodingError):
          completion(.failure(.error("Error decoding data: \(decodingError.localizedDescription)")))
        }
      } receiveValue: { decodedData in
        completion(.success(decodedData))
      }
      .store(in: &cancellables)
  }
}

enum APIError: Error {
  case error(_ errorString: String)
}

protocol APIServiceProtocol {
  func getJSON<T: Decodable>(url: URL, completion: @escaping (Result<T,APIError>) -> Void)
}
