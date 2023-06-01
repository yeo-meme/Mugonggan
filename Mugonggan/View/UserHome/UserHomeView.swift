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
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var userHomeModel : UserHomeViewModel
   
    
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
        let userHomeNameCell = UserHomeNameCell(viewModel)
        
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
                    CoverImageViw()
                    
                    
                    HStack{
                        UserHomeProfileCell()
                    }
             
                    
                   
                    Spacer()
                }
                
            }//: ZSTACK
            .navigationBarTitle(userHomeNameCell.nickName, displayMode: .inline)
            
            .navigationBarItems(leading: UserHomeProfileCell(),trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.large)
            })
            .onAppear {
                       // Update nickName when the view appears
                       userHomeNameCell.nickName = viewModel.currentUser?.name ?? ""
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
        .navigationBarBackButtonHidden(true)
    }
    
    var backButton: some View {
        NavigationLink(destination: MulistView()) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
    
    
    
    // MARK: - FETCH URL
//    func fetchImageUrls() {
//        guard let uid = viewModel.userSession?.uid else {return}
//
////        let storageRef = Storage.storage().reference()
////        let imgRef = storageRef.child("\(FOLDER_CHANNEL_IMAGES)/")
////
////        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
////
////
//
//
////        let ref = COLLECTION_CHANNELS.document(uid).collection("SUB").document()
//
//        COLLECTION_CHANNELS.document(uid).collection("SUB").getDocuments{( querySnapshot, error) in
//            if let error = error {
//                print("Failed to get documents: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found")
//                     return
//            }
//
//            for document in documents {
//                let data = document.data()
//                if let channelUrl = data[KEY_CHANNEL_IMAGE_URL] as? String {
//                    if let url = URL(string: channelUrl) {
//                        imageURLs.append(url)
//                        print("Profile URL: \(channelUrl)")
//                    }
//                }
////                selectedImage = imageURLs[0]
////                print("첫번째 셀렉티드: \(selectedImage)")
//            }
//        }
//
//
////        ref.listAll { (result, error) in
////            if let error = error {
////                print("Failed to fetch image URLs: \(error.localizedDescription)")
////                return
////            }
////            print("result:\(result?.items)")
////
////            if let items = result?.items {
////                for item in items {
////                    item.downloadURL{ url, error in
////                        if let error = error {
////                            print("Failed to fetch download URL: \(error.localizedDescription)")
////                            return
////                        }
////                        if let url = url {
////                            imageURLs.append(url)
////                        }
////                        selectedImage = imageURLs[0]
////                        print("첫번째 셀렉티드: \(selectedImage)")
////                    }
////                }
////            }
////        }
//    }
    
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
        UserHomeView(userHomeModel: UserHomeViewModel())
            .environmentObject(AuthViewModel())
    }
}
