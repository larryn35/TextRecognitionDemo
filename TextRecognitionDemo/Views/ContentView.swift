//
//  ContentView.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/3/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  @State private var inputImage: UIImage?
  @State private var isSheetPresented = false
  @State private var selectedSheetType: SheetType = .camera {
    didSet {
      isSheetPresented = true
    }
  }
  
  // Enum for multiple sheets (ImagePicker and InteractionsView)
  private enum SheetType {
    case camera
    case interactions
  }
  
  var body: some View {
    NavigationView {
      VStack {
        TabView {
          drugMatchesView
          
          textRecognizedView
          
          imageTakenView
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
      }
      .navigationBarTitle("Interaction checker")
      .navigationBarItems(
        trailing:
          Menu("Menu") {
            Button {
              selectedSheetType = .camera
            } label: {
              Label("Take photo", systemImage: "camera")
            }
            Button {
              selectedSheetType = .interactions
            } label: {
              Label("Check interactions", systemImage: "text.badge.checkmark")
            }
            .disabled(viewModel.drugMatches.count < 2) // Require 2 or more drug matches to perform interactions check
            Button {
              viewModel.clearList()
              inputImage = nil
            } label: {
              Label("Clear list", systemImage: "xmark.circle.fill")
                .foregroundColor(.red)
            }
          }
      )
    }
    .sheet(isPresented: $isSheetPresented, onDismiss: sheetAction) {
      switch selectedSheetType {
      case .camera:
        ImagePicker(image: $inputImage)
      case .interactions:
        InteractionsView(drugMatches: viewModel.drugMatches)
      }
    }
  }
  
  // MARK: - Tabview Views
  
  private var drugMatchesView: some View {
    VStack {
      Text("Drugs Found")
        .bold()
        .padding()
      
      List(viewModel.drugMatches, id: \.self) { drug in
        Text(drug.generic)
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
  
  private var textRecognizedView: some View {
    VStack {
      Text("Text Recognized (Post-scrubbing)")
        .bold()
        .padding()
      
      if viewModel.showErrorMessage {
        Text(viewModel.errorMessage)
          .bold()
          .padding()
          .foregroundColor(.red)
      }
      
      List(viewModel.cleanedResults, id: \.self) { drug in
        Text(drug)
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
  
  private var imageTakenView: some View {
    VStack {
      Text(viewModel.photoTabTitle)
        .bold()
        .padding()
      
      if let image = viewModel.image {
        image
          .resizable()
          .scaledToFit()
          .cornerRadius(10)
          .frame(minHeight: .none, maxHeight: .infinity, alignment: .top)
          .padding()
      } else {
        Text(viewModel.errorMessage)
          .bold()
          .padding()
          .foregroundColor(.red)
        Spacer()
      }
    }
  }
  
  // MARK: - Functions
  private func sheetAction() {
    viewModel.resetErrors()
    
    // Trigger load image on dismiss only if sheet was an ImagePicker
    if selectedSheetType == .camera {
      viewModel.loadImage(inputImage)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
