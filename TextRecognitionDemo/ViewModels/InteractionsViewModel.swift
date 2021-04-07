//
//  InteractionsViewModel.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

final class InteractionsViewModel: ObservableObject {
  @Published var interactions = [Interaction]()
  @Published var isSearchComplete = false
  @Published var errorMessage = ""
  @Published var showErrorMessage = false
  @Published var drugsChecked = 0
  
  let apiService: APIServiceProtocol
  var combineHelper: CombineHelperProtocol
  var drugMatches: [Drug]
  
  init(apiService: APIServiceProtocol = APIService(),
       combineHelper: CombineHelperProtocol = CombineHelper(),
       drugMatches: [Drug]) {
    self.apiService = apiService
    self.drugMatches = drugMatches
    self.combineHelper = combineHelper
  }
  
  var drugsCheckedText: String {
    "Drugs checked: \(drugsChecked)"
  }
}

// MARK:  Error handling

extension InteractionsViewModel {
  
  private enum InteractionsError {
    case missingDrug(count: Int)
    case mergeRequestError
    case invalidURL
    case jsonError
  }
  
  private func updateErrorMessage(for errorType: InteractionsError) {
    switch errorType {
    case .missingDrug(count: let count):
      if count > 1 {
        errorMessage = "Important: \(count) drugs from the list were not included in the check due to an error. This list may not include all possible interactions."
      } else {
        errorMessage = "Important: A drug from the list was not included in the check due to an error. This list may not include all possible interactions."
      }
    case .mergeRequestError:
      errorMessage = "Error: Unable to get information for drugs"
      
    case .invalidURL:
      errorMessage = "Error: URL is invalid"
      
    case .jsonError:
      errorMessage = "Error: Unable to get interactions from URL"
      interactions = []
    }
    
    showErrorMessage = true
    isSearchComplete = true
  }
}

// MARK: - Construct URL

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
}

// MARK: - Fetch data

extension InteractionsViewModel {
  
  func fetchInteractions() {
    let drugMatchesCount = drugMatches.count
    
    let urls = drugMatches.compactMap { $0.rxCuiURL }
    let requests = urls.map { combineHelper.createIDRequest(fromURL: $0) }
    
    combineHelper.mergeRequests(requests) { [weak self] drugIDs in
      if drugIDs.isEmpty {
        self?.updateErrorMessage(for: .mergeRequestError)
        return
      }
      
      self?.drugsChecked = drugIDs.count
      
      if drugMatchesCount > drugIDs.count {
        let drugsMissing = drugMatchesCount - drugIDs.count
        self?.updateErrorMessage(for: .missingDrug(count: drugsMissing))
      }
      
      self?.fetchJSON(for: drugIDs)
    }
  }
  
  private func fetchJSON(for ids: [String]) {
    let url = constructInteractionsURL(with: ids)
    
    guard let wrappedURL = url else {
      updateErrorMessage(for: .invalidURL)
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
        self?.updateErrorMessage(for: .jsonError)
      }
    }
  }
}
