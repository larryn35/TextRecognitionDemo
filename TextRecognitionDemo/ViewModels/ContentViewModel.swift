//
//  ContentViewModel.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
  @Published var inputImage: UIImage?
  @Published var image: Image?
  @Published var drugMatches = [String]()

  let recognizer: RecognizerServiceProtocol
  
  init(recognizer: RecognizerServiceProtocol = RecognizerService()) {
    self.recognizer = recognizer
  }
  
  // Load image from Camera into recognizer
  func loadImage() {
    guard let inputImage = inputImage else { return }
    recognizer.scanText(from: inputImage) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let results):
        let cleanedResults = self.cleanData(for: results)
        print("Results from recognizer:", cleanedResults)
        
        let matches = self.findMatches(results: cleanedResults)
        print("Matches:", matches)
        
        self.drugMatches = matches
        
      case .failure(let error):
        print(error)
      }
    }
  }
}

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
  private func findMatches(results: [String]) -> [String] {
    var drugMatchesSet = Set<String>()
    for drug in Data.sampleDrugBank {
      for result in results {
        if drug.startsWith(result) {
          drugMatchesSet.insert(drug)
        }
      }
    }
    
    let sortedArray = Array(drugMatchesSet).sorted()
    return sortedArray
  }
}