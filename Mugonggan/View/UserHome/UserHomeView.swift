//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI

struct UserHomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedImage: UIImage?
    @State private var uploadBtn: Image?
    //    @State private var pickedImage: Image?
    @State private var pickedImage: Image? = Image(systemName: "photo.artframe")
    
    @State private var openPhotoView = false
    
    @Binding var muListLinkActive : Bool
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack{
                    //엑스
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            muListLinkActive = false
//                        },label: {
//                            Image(systemName: "xmark")
//                                .resizable()
//                                .frame(width: 20,height: 20)
//                                .foregroundColor(.purple)
//                                .padding(.trailing,30)
//                        })
//                    }
                    
                    HStack{
                        UserHomeProfileCell()
                    }
//                    .padding(.top, 30)
             
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(images, id: \.self) { imageName in
                                
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            
            .overlay(
                ZStack{
                    Button(action: {
                        self.openPhotoView = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color.white))
                            .frame(width: 48,height: 48,alignment: .center)
                    })
                    .sheet(isPresented: $openPhotoView) {
                        UploadPhotoView()
                    }
                }//: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing,15) , alignment: .bottomTrailing
            )
        }
//        .navigationBarBackButtonHidden(true)
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        pickedImage = Image(uiImage:  selectedImage)
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView(muListLinkActive: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
