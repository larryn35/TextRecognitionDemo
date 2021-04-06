//
//  DrugInteraction.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

struct InteractionsContainer: Decodable {
  let fullInteractionTypeGroup: [FullInteractionTypeGroup]
}

struct FullInteractionTypeGroup: Decodable {
  let fullInteractionType: [FullInteractionType]
}

struct FullInteractionType: Decodable {
  let interactionPair: [Interaction]
}

struct Interaction: Decodable, Hashable {
  let description: String
}

extension InteractionsContainer {
  var interactions: [Interaction]? {
    var pairs = [Interaction]()
        
    guard let typeGroup = self.fullInteractionTypeGroup.first else { return nil }
    for types in typeGroup.fullInteractionType {
      guard let interactionPair = types.interactionPair.first else { return nil }
      pairs.append(interactionPair)
    }
    
    return pairs
  }
}
