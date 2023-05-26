//
//  IntroParagraph.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI

struct IntroParagraph: View {
    let title1: String
    let title2: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{ Spacer() }
       
            Text(title1)
                .font(.largeTitle)
                .bold()
            
            Text(title2)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.purple)
            
        }
//        .padding(.horizontal, 32)
    }
}


