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

  let recognizer: RecognizerServiceProtocol
  
  init(recognizer: RecognizerServiceProtocol = RecognizerService()) {
    self.recognizer = recognizer
  }
  
  // Load image from Camera into recognizer
  func loadImage() {
    guard let inputImage = inputImage else { return }
    recognizer.scanText(from: inputImage) { result in
      switch result {
      
      case .success(let results):
        print("Results from recognizer", results)
      case .failure(let error):
        print(error)
      }
    }
  }
}
