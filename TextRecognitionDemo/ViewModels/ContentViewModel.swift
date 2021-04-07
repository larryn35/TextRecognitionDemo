//
//  ContentViewModel.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
  @Published var image: Image?
  @Published var drugMatches = [Drug]()
  @Published var cleanedResults = [String]()
  @Published var showErrorMessage = false
  @Published var errorMessage = ""
  
  let recognizer: RecognizerServiceProtocol
  
  init(recognizer: RecognizerServiceProtocol = RecognizerService()) {
    self.recognizer = recognizer
  }
  
  var photoTabTitle: String {
    image != nil ? "Photo taken" : "No photo taken yet"
  }
  
  // Load image from Camera into recognizer
  func loadImage(_ inputImage: UIImage?) {
    guard let inputImage = inputImage else {
      errorMessage = "Failed to get picture from camera"
      showErrorMessage = true
      return
    }
    
    image = Image(uiImage: inputImage)
    
    recognizer.scanText(from: inputImage) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let results):
        let cleanedData = self.cleanData(for: results)
        self.cleanedResults = cleanedData
        
        let matches = self.findMatches(results: cleanedData)
        
        for drug in matches {
          if !self.drugMatches.contains(drug) {
            self.drugMatches.append(drug)
          }
        }
        
      case .failure:
        self.errorMessage = "Failed to process image"
        self.showErrorMessage = true
        self.drugMatches = []
      }
    }
  }
  
  func clearList() {
    drugMatches = []
    cleanedResults = []
    image = nil
  }
  
  func resetErrors() {
    showErrorMessage = false
    errorMessage = ""
  }
}

// MARK:  Data processing

extension ContentViewModel {
  /// Clean results returned from text recognizer.
  /// - Parameters:
  ///   - results: Array of strings returned from recognizer
  ///   - minCharactersPerResult: An Int that represents the minimum length that a string from the results array must be or the string will be removed from the array. Default: 4
  /// - Returns: Array of strings containing just letters and are of length minCharactersPerResult or more
  private func cleanData(for results: [String], minCharactersPerResult: Int = 4) -> [String] {
    let formattedStrings = results.map { $0.returnOnlyLetters() }
    let meetsCharacterLimit = formattedStrings.filter { $0.count >= minCharactersPerResult }
    return meetsCharacterLimit
  }
  
  /// Matches results to drug bank
  /// - Parameter results: An array of cleaned strings from the recognizer
  /// - Returns: A sorted array of strings representing drugs from the drug bank whose prefix is equal to a string from the results
  private func findMatches(results: [String]) -> [Drug] {
    var drugMatchesSet = Set<Drug>()
    for drug in Drugbank.drugs {
      for result in results {
        if drug.generic.startsWith(result) {
          drugMatchesSet.insert(drug)
        }
      }
    }
    let sortedArray = Array(drugMatchesSet).sorted()
    return sortedArray
  }
}
