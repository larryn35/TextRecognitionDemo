//
//  ContentView.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/3/21.
//

import SwiftUI

struct ContentView: View {
  // MARK: - Properties

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
  
  // MARK:  - Body
  
  var body: some View {
    NavigationView {
      TabView {
        drugMatchesView
        
        imageTakenView
        
        textRecognizedView
        
      }
      .tabViewStyle(PageTabViewStyle())
      .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
        leading: Text("Interactions Checker"),
        trailing: menuView)
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
    List {
      Section(header: Text(viewModel.drugMatchesTabText)) {
        if viewModel.drugMatches.isEmpty {
          Text("No results found")
        } else {
          ForEach(viewModel.drugMatches, id: \.self) { drug in
            Text(drug.generic)
              .onLongPressGesture {
                remove(drug)
              }
          }
        }
      }
      if viewModel.showErrorMessage {
        Section(header: Text("Error")) {
          Text(viewModel.errorMessage)
            .foregroundColor(.red)
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
  
  private var textRecognizedView: some View {
    List {
      Section(header: Text("Text recognized (Post-scrub)")) {
        if viewModel.cleanedResults.isEmpty {
          Text("No results found")
        } else {
          ForEach(viewModel.cleanedResults, id: \.self) { text in
            Text(text)
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
  
  private var imageTakenView: some View {
    List {
      Section(header: Text("Photo taken")) {
        if let image = viewModel.image {
          image
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(minHeight: .none, maxHeight: .infinity, alignment: .center)
        } else {
          Text("Photo not found")
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
  
  // MARK: - Menu view
  
  private var menuView: some View {
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
  
  private func remove(_ drug: Drug) {
    if let index = viewModel.drugMatches.firstIndex(of: drug) {
      viewModel.drugMatches.remove(at: index)
    }
  }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
