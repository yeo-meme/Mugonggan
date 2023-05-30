//
//  UploadPhotoView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI

struct UploadChannelPhotoView: View {
  
    @State private var imagePickerPresented : Bool = false
    @State private var selectedImage: UIImage?
    @State private var muUploadImage: Image?
    @State private var isIndicatorAnimating: Bool = false
    @EnvironmentObject var viewModel : AuthViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        VStack{
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
            }
                .padding(.trailing,30)
            }
            .padding(.top, -80)
            
            IntroParagraph(title1: "공유해보세요",title2:"당신만의 \n(사)무공간을")
            
            
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
            
           
            CapsuleButton(text: "다음",
                          disabled: muUploadImage == nil,
                          isAnimating: isIndicatorAnimating,
                          action: {
//                print("image가 null이니? \(muUploadImage)")
                isIndicatorAnimating = true
//                viewModel.test(selectedImage!)
                viewModel.uploadChannelImage(selectedImage!)
                { success in
                    if success {
                        isIndicatorAnimating = false
                        self.presentationMode.wrappedValue.dismiss()
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

struct UploadChannelPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadChannelPhotoView()
            .environmentObject(AuthViewModel())
    }
}
