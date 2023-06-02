//
//  LikeCell.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI
import Kingfisher

struct LikeCell: View {
    let channel: Channel
    
    var body: some View {
            VStack(spacing: 1) {
                HStack(spacing: 12) {
          
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(channel.name)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                        }
                        
                    
                    }
                    
                    Spacer()
                }
                .frame(height: 80)
                .background(Color.white)
                
                CustomDivider(leadingSpace: 84)
        }
    }
}
