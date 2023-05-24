//
//  ImagePicker.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
   
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    
    }
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        return imagePicker
    }

}
