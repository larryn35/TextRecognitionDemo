//
//  InteractionsView.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import SwiftUI

struct InteractionsView: View {
  @ObservedObject private var viewModel: InteractionsViewModel
  
  init(drugMatches: [Drug]) {
    viewModel = InteractionsViewModel(drugMatches: drugMatches)
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if viewModel.isSearchComplete {
          Form {
            Section(header: Text(viewModel.drugsCheckedText)) {
              ForEach(viewModel.interactions, id: \.self) { interaction in
                Text(interaction.description)
              }
            }
            
            if viewModel.showErrorMessage {
              Section {
                Text(viewModel.errorMessage)
                  .font(.subheadline)
                  .foregroundColor(.red)
              }
            }
            
            if !viewModel.missedDrugs.isEmpty {
              Section(header: Text("Drugs excluded from check due to error")) {
                ForEach(viewModel.missedDrugs, id: \.self) { drug in
                  Text(drug)
                }
              }
            }
          }
        } else {
          Text("Interaction check in progress")
            .padding()
        }
      }
      .navigationTitle("Interactions")
    }
    .onAppear(perform: viewModel.fetchInteractions)
  }
}

struct InteractionsView_Previews: PreviewProvider {
  static var previews: some View {
    InteractionsView(drugMatches: [Drug(generic: "Lisinopril")])
  }
}
