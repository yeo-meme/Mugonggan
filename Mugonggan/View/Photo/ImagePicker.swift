//
//  ImagePicker.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.image = image
            self.parent.mode.wrappedValue.dismiss()
        }
    }
    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//
//        return imagePicker
//    }

}
