//
//  HelperFunctions.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/6/21.
//

import Foundation
import Combine

struct CombineHelper: CombineHelperProtocol {
  private var cancellables = Set<AnyCancellable>()

  func createIDRequest(fromURL: URL) -> AnyPublisher<String, Never> {
    let request = URLRequest(url: fromURL)
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: RxCui.self, decoder: JSONDecoder())
      .compactMap { $0.id }
      .replaceError(with: "")
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  mutating func mergeRequests(_ requests:  [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void) {
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
  func createIDRequest(fromURL: URL) -> AnyPublisher<String, Never>
  mutating func mergeRequests(_ requests:  [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void)

}
