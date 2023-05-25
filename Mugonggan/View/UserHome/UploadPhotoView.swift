//
//  UploadPhotoView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI

struct UploadPhotoView: View {
    @State private var imagePickerPresented : Bool = false
    @State private var selectedImage: UIImage?
    @State private var muUploadImage: Image?
    @State private var isIndicatorAnimating: Bool = false
    
    @EnvironmentObject var viewModel :  AuthViewModel
    
    var body: some View {

        VStack{
            IntroParagraph(title1: "Select your profile image")
            
            
            Button(action: {
                imagePickerPresented.toggle()
            }, label: {
                
                if let muUploadImage = muUploadImage {
                    muUploadImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 240,height:240)
                        .clipShape(Circle())
                } else {
                    Text("Click here")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 240, height: 240)
                        .clipShape(Circle())
                        .overlay(Circle().stroke( style:StrokeStyle(lineWidth: 2, dash: [5])))
                }
            })
            .padding(.top, 56)
            .padding(.bottom)
            .sheet(isPresented: $imagePickerPresented, onDismiss: loadImage, content:{ ImagePicker(image:$selectedImage)})
            
            CapsuleButton(text: "Continue",
                          disabled: muUploadImage == nil,
                          isAnimating: isIndicatorAnimating, action: {
                isIndicatorAnimating = true
                viewModel.uploadProfileImage(selectedImage!) { success in
                    if success {
                        isIndicatorAnimating = false
                        print("사진등록이완료되었움")
                    } else {
                        print("사진등록이완료되지 않았움")
                    }
                }
                
            })
        }
            
    }
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        muUploadImage = Image(uiImage: selectedImage)
    }
}

struct UploadPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoView()
    }
}
