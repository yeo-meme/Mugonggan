//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct UserHomeView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
   
    
    @State private var selectedImage: UIImage?
    @State private var uploadBtn: Image?
    @State private var pickedImage: Image? = Image(systemName: "photo.artframe")
    @State private var openPhotoView = false
//    @Binding var muListLinkActive : Bool
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var imageURLs:[URL] = []
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack{
                    NavigationLink(destination: SettingView(viewModel.currentUser ?? MOCK_USER), label: {
                        HStack{
                            Spacer()
                            Text("설정")
                            Image(systemName: "sparkles")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing,15)
                        }
                    })
               
                    
                    // MARK: - 엑스
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
             
                    
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(imageURLs, id: \.self) { imageURL in
//                            NavigationLink(destination: MuDetailView() ,isActive: $muListLinkActive){
                                
                                WebImage(url: imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: imageSize  , height: imageSize)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    .onTapGesture {
                             
                                    }
//                            }
                        }
                    } //: GRID
                    .onAppear{
                       
                    }
                    
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
            // MARK: - PLUS BTN
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
                        UploadChannelPhotoView()
                    }
                }//: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing,15) , alignment: .bottomTrailing
            )
        }
//        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - FETCH URL
    func fetchImageUrls() {
        guard let uid = viewModel.userSession?.uid else {return}
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child("\(FOLDER_CHANNEL_IMAGES)/")
        
        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
        
        
        
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed to fetch image URLs: \(error.localizedDescription)")
                return
            }
            print("result:\(result?.items)")
            
            if let items = result?.items {
                for item in items {
                    item.downloadURL{ url, error in
                        if let error = error {
                            print("Failed to fetch download URL: \(error.localizedDescription)")
                            return
                        }
                        if let url = url {
                            imageURLs.append(url)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - LOAD IMAGE
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        pickedImage = Image(uiImage:  selectedImage)
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView()
            .environmentObject(AuthViewModel())
    }
}
