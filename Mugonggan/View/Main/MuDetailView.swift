//
//  MuDetailView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/23.
//

import SwiftUI

struct MuDetailView: View {
    let selectedImage: URL?
    @EnvironmentObject var viewModel: AuthViewModel

    
    var body: some View {
        
        VStack(spacing: 1) {
            HStack{
                
//                UserHomeProfileCell()
         
                Button(action: {}) {
                    Text("팔로우")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            if let imageURL = selectedImage {
                       Text("Selected Image: \(imageURL)")
                   } else {
                       Text("No Image Selected")
                   }
            
            
            
            HStack(spacing: 70) {
                
                VStack{
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("알림")
                }
                VStack{
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("즐겨찾기")
                }
                VStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("좋아요")
                }
                
               
            }
            .frame(maxWidth: .infinity, maxHeight: 70)
            .padding()
            .cornerRadius(10)
            
            
            CustomDivider(leadingSpace: 100)
            
            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
          
            Spacer()
        }
        
    }
}

struct MuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MuDetailView(selectedImage: nil)
            .environmentObject(AuthViewModel())
    }
}
