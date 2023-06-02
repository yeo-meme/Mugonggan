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
    
    @State private var imageURLs:[URL] = []
    
    var body: some View {
        TabView{
            ForEach(imageURLs, id: \.self) { imageURL in
                WebImage(url: imageURL)
                    .resizable()
                    .scaledToFill()
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

struct CoverImageViw_Previews: PreviewProvider {
    static var previews: some View {
        CoverImageViw()
            .environmentObject(AuthViewModel())
    }
}
