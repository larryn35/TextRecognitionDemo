//
//  RecognizerService.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import UIKit
import MLKit

struct RecognizerService {
  func scanText(from image: UIImage) -> [String] {
    var results = [String]()
    
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    
    let textRecognizer = TextRecognizer.textRecognizer()
    
    textRecognizer.process(visionImage) { result, error in
      guard error == nil, let result = result else {
        // Error handling
        print("Error processing image")
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
    }
    
    return results
  }
}
