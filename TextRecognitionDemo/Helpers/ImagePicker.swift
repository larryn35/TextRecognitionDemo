//
//  ImagePicker.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/4/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @Binding var image: UIImage?
  
  var sourceType: UIImagePickerController.SourceType = .camera
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = sourceType
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let uiImage = info[.editedImage] as? UIImage {
        parent.image = uiImage
      }
      
      parent.presentationMode.wrappedValue.dismiss()
    }
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

