//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI

struct UserHomeView: View {
    @State private var selectedImage: UIImage?
    @State private var profileIamge: Image?
    @State private var openPhoto = false
    
    @Binding var muListLinkActive : Bool
    
    var body: some View {
     
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    muListLinkActive = false
                },label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .foregroundColor(.purple)
                    .padding(.trailing,30)
                })
            }
            HStack{
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 50,height: 50)
                    .foregroundColor(.purple)

                VStack{
                    Text("먀아아아아아")
                    Text("유저홈이다 뭐가필요해")
                }
              
               
               
                
            }
            .padding(.top, 30)
            
            
            HStack {
                let image: Image = selectedImage == nil ? Image(systemName: "plus.circle") : Image(systemName: "plus.square")  ?? Image(systemName: "plus.circle")
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 50,height: 50)
                    .foregroundColor(.purple)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        self.openPhoto = true
                    }) {
                        
                        if let profileIamge = profileIamge {
                            profileIamge
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Text("사진올리기")
                                .foregroundColor(.white)
                        }
                    }
                    .sheet(isPresented: $openPhoto,
                           onDismiss: loadImage,
                           content: {ImagePicker(image: $selectedImage)})
//                    .sheet(isPresented: $openPhoto) {
//                        ImagePicker(sourceType: .photoLibrary)
//                    }
                }
                
                .frame(width: 100, height: 50)
                .background(.purple)
                .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        profileIamge = Image(uiImage:  selectedImage)
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView(muListLinkActive: .constant(true))
    }
}
