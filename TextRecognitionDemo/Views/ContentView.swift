//
//  ContentView.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/3/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  @State private var showingImagePicker = false
  
  var body: some View {
    VStack {
      Button("Take photo") {
        showingImagePicker = true
      }
    }
    .sheet(isPresented: $showingImagePicker, onDismiss: viewModel.loadImage) {
      ImagePicker(image: $viewModel.inputImage)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
