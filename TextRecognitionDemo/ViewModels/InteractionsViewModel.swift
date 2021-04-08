//
//  InteractionsViewModel.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import SwiftUI
import Combine

final class InteractionsViewModel: ObservableObject {
  @Published var interactions = [Interaction]()
  @Published var isSearchComplete = false
  @Published var drugsDoNotInteract = false
  @Published var showInteractionsMessage = false
  @Published var interactionsMessage = ""
  @Published var drugsChecked = 0
  @Published var missedDrugs = [String]()
  
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
    let missedDrugsSet = Set(missedDrugs)
    var drugMatchesSet = Set(drugMatches.map { $0.generic })
    
    // Removes missed drugs from drugMatches
    drugMatchesSet.formSymmetricDifference(missedDrugsSet)
    
    if drugMatchesSet.isEmpty {
      return "No drugs checked"
    } else {
      let sortedArray = Array(drugMatchesSet).sorted()
      return sortedArray.joined(separator: ", ")
    }
  }
}

// MARK: - Fetch data

extension InteractionsViewModel {
  
  // 1. Create requests for RxCuis (createIDRequest)
  // 2. Merges and performs requests (combineHelper.mergeRequests)
  // 3. RxCuis passed into fetchJSON, where it's joined
  // 4. Interactions URL constructed from joined string (constructInteractionsURL)
  // 5. Interactions request performed with URL (apiService.getJSON)
  
  func fetchInteractions() {
    let drugMatchesCount = drugMatches.count
    let requests = drugMatches.map { createIDRequest(for: $0) }
    
    combineHelper.mergeRequests(requests) { [weak self] drugIDs in
      if drugIDs.isEmpty {
        self?.updateInteractionsMessage(for: .mergeRequestError)
        return
      }
      
      self?.drugsChecked = drugIDs.count
      
      if drugMatchesCount > drugIDs.count {
        let drugsMissing = drugMatchesCount - drugIDs.count
        self?.updateInteractionsMessage(for: .missingDrug(count: drugsMissing))
      }
      
      self?.fetchJSON(for: drugIDs)
    }
  }
}

// MARK: - Fetch components

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
  
  func createIDRequest(for drug: Drug) -> AnyPublisher<String, Never> {
    guard let url = drug.rxCuiURL else {
      return Just("").eraseToAnyPublisher()
    }
    
    let request = URLRequest(url: url)
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: RxCui.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .compactMap { $0.id }
      .catch { [weak self] error -> Just<String> in
        self?.missedDrugs.append(drug.generic)
        return Just("")
      }
      .eraseToAnyPublisher()
  }
  
  private func fetchJSON(for ids: [String]) {
    let url = constructInteractionsURL(with: ids)
    
    guard let wrappedURL = url else {
      updateInteractionsMessage(for: .invalidURL)
      return
    }
    
    apiService.getJSON(url: wrappedURL) { [weak self] (result: Result<InteractionsContainer, APIError>) in
      switch result {
      case .success(let fetched):
        guard let fetchedInteractions = fetched.interactions else {
          
          // Drugs do not interact
          self?.drugsDoNotInteract = true
          self?.isSearchComplete = true
          return
        }
        
        let interactionsSet = Set(fetchedInteractions)
        self?.interactions = Array(interactionsSet)
        self?.isSearchComplete = true
        
      case .failure(let error):
        switch error {
        case .error(let message):
          print(message)
          self?.updateInteractionsMessage(for: .jsonError)
        }
      }
    }
  }
}

// MARK: - Error handling

extension InteractionsViewModel {
  
  private enum InteractionsOutcome {
    case missingDrug(count: Int)
    case mergeRequestError
    case invalidURL
    case jsonError
  }
  
  private func updateInteractionsMessage(for outcome: InteractionsOutcome) {
    switch outcome {
    case .missingDrug(count: let count):
      interactionsMessage = "Unable to retrieve information for \(count) drug(s) from the list. This list may not include all possible interactions."
      
    case .mergeRequestError:
      interactionsMessage = "Error: Unable to get information for drugs"
      
    case .invalidURL:
      interactionsMessage = "Error: URL is invalid"
      
    case .jsonError:
        interactionsMessage = "Error: Unable to get interactions from URL"
        interactions = []
    }
    
    showInteractionsMessage = true
    isSearchComplete = true
  }
}
