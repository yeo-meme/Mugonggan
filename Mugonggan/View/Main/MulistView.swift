//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI
import FirebaseStorage

struct MulistView: View {
    
   
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
                    ForEach(images, id: \.self) { imageName in
                        NavigationLink(destination: MuDetailView(muListLinkActive : $muListLinkActive) ,isActive: $muListLinkActive){
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
     
    }
    
//    func uploadImage() {
//        guard let image = seletedImage else {
//            return
//        }
//        
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {return}
//        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let imageRef = storageRef.child("images/iamge.jpg")
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        
//        imageRef.putData(imageData, metadata: metadata) { _, error in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//            } else {
//                print("image upload 성공")
//            }
//            
//    }
//    
//    
//    }
}




struct MulistView_Previews: PreviewProvider {
    static var previews: some View {
        MulistView()
            .environmentObject(AuthViewModel())
    }
}
