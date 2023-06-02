//
//  CoverImageViw.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct CoverImageViw: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    @State private var imageURLs:[URL] = []
    
    var body: some View {
        TabView{
            ForEach(imageURLs, id: \.self) { imageURL in
                WebImage(url: imageURL)
                    .resizable()
                    .scaledToFill()
//                    .clipShape(Circle())
//                    .frame(width: 150 , height: 150)
//                    .overlay(Circle().stroke(Color.white, lineWidth: 8))
                    .onTapGesture {
                    }
            }//: LOOP
        }//: TAB
        .tabViewStyle(PageTabViewStyle())
        .onAppear{
            fetchImageUrls()
        }
    }
    
    // MARK: - FETCH URL
    func fetchImageUrls() {
        guard let uid = viewModel.currentUser?.uid else {
            return
        }
        
//        let storageRef = Storage.storage().reference()
//        let imgRef = storageRef.child("\(FOLDER_CHANNEL_IMAGES)/")
//
//        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
//
//
        
        
//        let ref = COLLECTION_CHANNELS.document(uid).collection("SUB").document()
        
        COLLECTION_CHANNELS.document(uid).collection("SUB").getDocuments{( querySnapshot, error) in
            if let error = error {
                print("Failed to get documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                     return
            }

            for document in documents {
                let data = document.data()
                if let channelUrl = data[KEY_CHANNEL_IMAGE_URL] as? String {
                    if let url = URL(string: channelUrl) {
                        imageURLs.append(url)
                        print("Profile URL: \(channelUrl)")
                    }
                }
//                selectedImage = imageURLs[0]
//                print("첫번째 셀렉티드: \(selectedImage)")
            }
        }
        
        
//        ref.listAll { (result, error) in
//            if let error = error {
//                print("Failed to fetch image URLs: \(error.localizedDescription)")
//                return
//            }
//            print("result:\(result?.items)")
//
//            if let items = result?.items {
//                for item in items {
//                    item.downloadURL{ url, error in
//                        if let error = error {
//                            print("Failed to fetch download URL: \(error.localizedDescription)")
//                            return
//                        }
//                        if let url = url {
//                            imageURLs.append(url)
//                        }
//                        selectedImage = imageURLs[0]
//                        print("첫번째 셀렉티드: \(selectedImage)")
//                    }
//                }
//            }
//        }
    }
}
//
struct CoverImageViw_Previews: PreviewProvider {
    static var previews: some View {
        CoverImageViw()
            .environmentObject(AuthViewModel())
    }
}
