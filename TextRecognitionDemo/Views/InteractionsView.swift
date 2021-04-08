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
            Section {
              if viewModel.drugsDoNotInteract {
                Text("No interactions found")
              }
              
              ForEach(viewModel.interactions, id: \.self) { interaction in
                Text(interaction.description)
              }
            }
            
            Section(header: Text("Drugs checked")) {
              Text(viewModel.drugsCheckedText)
                .font(.subheadline)
            }
            
            if viewModel.showInteractionsMessage {
              Section(header: Text("Attention")) {
                Text(viewModel.interactionsMessage)
                  .font(.subheadline)
                  .foregroundColor(.red)
              }
            }
            
            if !viewModel.missedDrugs.isEmpty {
              Section(header: Text("Drugs excluded from check")) {
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
