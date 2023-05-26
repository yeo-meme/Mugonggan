//
//  CustomDivider.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/26.
//

import SwiftUI

struct CustomDivider: View {
    let leadingSpace: CGFloat
    
    var body: some View {
      Divider()
            .background(Color(.systemGray6))
            .padding(.leading, leadingSpace)
    }
}

