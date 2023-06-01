//
//  ProfilePhotoSelectorView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/30.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isIndicatorAnimating = false
    
    var body: some View {
        VStack{
            Spacer()
            IntroParagraph(title1: profileImage == nil ?
                           "안녕하세요, \(viewModel.tempCurrentUsername)!" :
                            "멋진 프로필 사진이네요!", title2: profileImage == nil ?
                           "프로필 사진을 골라보세요" : "다음을 눌러 계속 진행해주세요")
            
            Button(action: {
                imagePickerPresented.toggle()
            }) {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 240, height: 240)
                        .clipShape(Circle())
                } else {
                    Text("여기를 누르세요!")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 240, height: 240)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [5])))
                }
            }
            .padding(.top, 56)
            .padding(.bottom)
            .sheet(isPresented: $imagePickerPresented, onDismiss: loadImg,
            content: {
                ImagePicker(image: $selectedImage)
            })
            
            CapsuleButton(text: "다음", disabled: profileImage == nil, isAnimating: isIndicatorAnimating,
                          action: {
                isIndicatorAnimating = true
                viewModel.uploadProfileImage(selectedImage!) { success in
                    if success {
                        
                    } else {
                        
                    }
                         
                }
            }
            )
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .showErrorMessage(showAlert:$viewModel.showErrorAlert, message: viewModel.errorMessage)
    }
    
    func loadImg() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
            .environmentObject(AuthViewModel())
    }
}
