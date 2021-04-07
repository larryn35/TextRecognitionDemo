//
//  File.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/6/21.
//

import Foundation

struct Drug: Hashable {
  let generic: String
}

extension Drug: Comparable {
  static func < (lhs: Drug, rhs: Drug) -> Bool {
    lhs.generic < rhs.generic
  }
}

extension Drug {
  var rxCuiURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "rxnav.nlm.nih.gov"
    components.path = "/REST/rxcui.json"
    components.queryItems = [
      URLQueryItem(name: "name", value: self.generic),
      URLQueryItem(name: "search", value: "1")
    ]
    return components.url
  }
}
