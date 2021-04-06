//
//  InteractionsViewModel.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation
import Combine

final class InteractionsViewModel: ObservableObject {
  @Published var interactions = [Interaction]()
  @Published var isSearchComplete = false
  @Published var errorMessage = ""
  @Published var showErrorMessage = false
  
  var apiService: APIServiceProtocol
  var drugMatches: [String]
  var cancellables = Set<AnyCancellable>()
  var filteredRequests = [AnyPublisher<String, Never>]()

  init(apiService: APIServiceProtocol = APIService(),
       drugMatches: [String]) {
    self.apiService = apiService
    self.drugMatches = drugMatches
  }
}

// MARK: - Construct URLs

extension InteractionsViewModel {
  
  func constructInteractionsURL(with ids: [String]) -> URL? {
    let joinedIDs = ids.joined(separator: "+")
    
    var interactionsURL: URL? {
      var components = URLComponents()
      components.scheme = "https"
      components.host = "rxnav.nlm.nih.gov"
      components.path = "/REST/interaction/list.json"
      components.queryItems = [
        URLQueryItem(name: "rxcuis", value: joinedIDs),
      ]
      
      return components.url
    }
    return interactionsURL
  }
  
  func constructRxCuiURL(for drug: String) -> URL? {
    var rxCuiURL: URL? {
      var components = URLComponents()
      components.scheme = "https"
      components.host = "rxnav.nlm.nih.gov"
      components.path = "/REST/rxcui.json"
      components.queryItems = [
        URLQueryItem(name: "name", value: drug),
        URLQueryItem(name: "search", value: "1")
      ]
      
      return components.url
    }
    return rxCuiURL
  }
}
  
// MARK: - Fetch data

extension InteractionsViewModel {
  
  func fetchDrugIDsAndInteractions() {
  
    let urls = drugMatches.map { constructRxCuiURL(for: $0) }
    
    guard !urls.contains(nil) else {
      errorMessage = "Error constructing RxCui URL for drug(s)"
      showErrorMessage = true
      isSearchComplete = true
      return
    }
    
    let requests = urls.map {
      apiService.createIDRequest(url: $0!)
    }

    apiService.mergeRequests(requests) { [weak self] (result: Result<[String], APIError>) in
      switch result {
      case .success(let ids):
        self?.fetchInteractions(for: ids)
      case .failure(let error):
        print(error.localizedDescription)
        self?.errorMessage = "Error merging requests"
        self?.showErrorMessage = true
        self?.isSearchComplete = true
      }
    }
  }
  
  private func fetchInteractions(for ids: [String]) {
    let url = constructInteractionsURL(with: ids)
    
    guard let wrappedURL = url else {
      errorMessage = "Error constructing interactions URL"
      showErrorMessage = true
      isSearchComplete = true
      return
    }
    
    apiService.getJSON(url: wrappedURL) { [weak self] (result: Result<InteractionsContainer, APIError>) in
      switch result {
      case .success(let fetched):
        guard let fetchedInteractions = fetched.interactions else { return }
        let interactionsSet = Set(fetchedInteractions)
        self?.interactions = Array(interactionsSet)
        self?.isSearchComplete = true
      case .failure(let error):
        print(error.localizedDescription)
        self?.errorMessage = "Error checking for interactions"
        self?.showErrorMessage = true
        self?.interactions = []
        self?.isSearchComplete = true
      }
    }
  }
}
