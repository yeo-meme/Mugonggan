//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MulistView: View {
  
    @State private var imageURLs:[URL] = []
   
    @EnvironmentObject var viewModel: AuthViewModel
    @State var muListLinkActive = false
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    
                    Spacer()
                    NavigationLink(destination: UserHomeView( muListLinkActive: $muListLinkActive)) {
                        Text("메메님 방가루")
                    }
                }
                .padding(.top,20)
                .padding(.trailing,20)
                
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("logout")
                }
                
                
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(imageURLs, id: \.self) { imageURL in
                        NavigationLink(destination: MuDetailView(muListLinkActive : $muListLinkActive) ,isActive: $muListLinkActive){
                            
                            WebImage(url: imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width:100, height:100)
                                .cornerRadius(10)
                                .padding(4)
                         
                                
//                            Image(imageName)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(height: 150)
//                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                fetchImageUrls()
            }
        }
     
    }
    
    
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
}




struct MulistView_Previews: PreviewProvider {
    static var previews: some View {
        MulistView()
            .environmentObject(AuthViewModel())
    }
}
