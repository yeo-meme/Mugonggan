//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI

struct MulistView: View {
    
    
    @State var muListLinkActive = false
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer()
                    Text("메메님 방가루")
                }
                .padding(.top,20)
                .padding(.trailing,20)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(images, id: \.self) { imageName in
                       
                        NavigationLink(destination: MuDetailView(muListLinkActive : $muListLinkActive) , isActive: $muListLinkActive){
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
}




struct MulistView_Previews: PreviewProvider {
    static var previews: some View {
        MulistView()
    }
}
