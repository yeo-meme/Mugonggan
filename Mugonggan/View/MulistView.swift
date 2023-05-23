//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI

struct MulistView: View {
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ScrollView {
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
        }
    }
}

struct MulistView_Previews: PreviewProvider {
    static var previews: some View {
        MulistView()
    }
}
