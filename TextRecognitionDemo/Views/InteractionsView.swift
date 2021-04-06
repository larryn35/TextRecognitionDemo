//
//  InteractionsView.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import SwiftUI

struct InteractionsView: View {
  @ObservedObject private var viewModel: InteractionsViewModel
  
  init(drugMatches: [String]) {
    viewModel = InteractionsViewModel(drugMatches: drugMatches)
    viewModel.fetchDrugIDsAndInteractions()
  }
  
  var body: some View {
    if viewModel.isSearchComplete {
      Form {
        Section(header: Text("Interactions")) {
          ForEach(viewModel.interactions, id: \.self) { interaction in
            Text(interaction.description)
          }
        }
        
        if viewModel.showErrorMessage {
          Section(header: Text("Error")) {
            Text(viewModel.errorMessage)
              .fontWeight(.semibold)
              .foregroundColor(.red)
          }
        }
      }
    } else {
      Text("Interaction check in progress")
        .padding()
    }
  }
}

struct InteractionsView_Previews: PreviewProvider {
  static var previews: some View {
    InteractionsView(drugMatches: [""])
  }
}
