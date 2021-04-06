//
//  RxCui.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

struct RxCui: Decodable {
  let idGroup: IdGroup
}

struct IdGroup: Decodable {
  let name: String
  let rxnormID: [String]

  private enum CodingKeys: String, CodingKey {
    case name
    case rxnormID = "rxnormId"
  }
}

extension RxCui {
  var id: String {
    guard let id = self.idGroup.rxnormID.first else {
      return "error"
    }
    return id
  }
}
