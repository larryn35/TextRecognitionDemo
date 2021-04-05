//
//  RecognizerService.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import UIKit
import MLKit

struct RecognizerService: RecognizerServiceProtocol {
  
  func scanText(from image: UIImage, completion: @escaping (Result<[String],RecognizerError>) -> Void) {
    var results = [String]()
    
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    
    let textRecognizer = TextRecognizer.textRecognizer()
    
    textRecognizer.process(visionImage) { result, error in
      guard error == nil, let result = result else {
        // Error handling
        completion(.failure(.error("textRecognizer unable to process image")))
        return
      }
      // Recognized text
      for block in result.blocks {
        for line in block.lines {
          for element in line.elements {
            let elementText = element.text
            results.append(elementText)
          }
        }
      }
      completion(.success(results))
    }
  }
}

enum RecognizerError: Error {
  case error(_ errorString: String)
}

protocol RecognizerServiceProtocol {
  func scanText(from image: UIImage, completion: @escaping (Result<[String],RecognizerError>) -> Void)
}
