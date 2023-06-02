//
//  MyUploadImageView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI
import FirebaseStorage
import Kingfisher

struct MyUploadImageView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    
    @State private var imageURLs:[URL] = []
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(imageURLs, id: \.self) { imageName in
                KFImage(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .cornerRadius(10)
            }
        }
        .onAppear{
            fetchImageUrls()
        }
        .padding()
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
            }
        }
    }
}

struct MyUploadImageView_Previews: PreviewProvider {
    static var previews: some View {
        MyUploadImageView()
    }
}
