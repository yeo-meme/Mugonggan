//
//  EditProfileView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    @Environment(\.presentationMode) var mode
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var username = AuthViewModel.shared.currentUser?.name ?? ""
        
    init(_ viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 1) {
                HStack {
                    Text("이미지나 당신의 이름을 클릭해서 변경해보세요")
                        .font(.system(size: 14))
                        .padding(.leading)
                        .foregroundColor(Color(.systemGray2))
                    
                    Spacer()
                }
                .padding(.top, 32)
                
                VStack {
                    EditProfileCell(viewModel: viewModel,
                                    showImagePicker: $showImagePicker,
                                    selectedImage: $selectedImage)
                    
                    CustomDivider(leadingSpace: 16)
                    
                    EditUsernameCell(viewModel: viewModel,
                                     username: $username)
                }
                .background(Color.white)
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("STATUS")
                        .font(.system(size: 14))
                        .padding(.leading)
                        .foregroundColor(Color(.systemGray2))
                    
//                    NavigationLink(
//                        destination: StatusSelectorView(viewModel),
//                        label: {
//                            EditStatusCell(viewModel: viewModel)
//                        }
//                    )
                }
                .padding(.top)
                
                Spacer()
            }
        }
        .showErrorMessage(showAlert: $viewModel.showErrorAlert, message: viewModel.errorMessage)
        .navigationBarItems(trailing: DoneButton)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Profile")
    }
    
    var DoneButton: some View {
        Button {
            viewModel.updateProfile(image: selectedImage, username: username)
            mode.wrappedValue.dismiss()
        } label: {
            Text(viewModel.getButtonLabel(image: selectedImage, username: username))
                .font(.system(size: 16, weight: .semibold))
        }
    }
}


