//
//  SettingsCell.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI

struct SettingsCell: View {
    let viewModel: SettingsCellViewModel
    var body: some View {
        VStack {
            HStack {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(6)
                    .foregroundColor(.white)
                    .background(viewModel.backgroundColor)
                    .cornerRadius(6)
                
                Text(viewModel.title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.forward").foregroundColor(Color(.systemGray4))
            }
            .padding([.top, .horizontal])
            
            CustomDivider(leadingSpace: 56)
        }
        .background(Color.white)
    }
}
