//
//  SettingsProfile.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI
import Kingfisher


struct SettingsProfile: View {
    @ObservedObject var viewModel : EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        HStack{
            KFImage(URL(string: viewModel.user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.user.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            Image(systemName: "chevron.forward").foregroundColor(Color(.systemGray4))
        }
        .padding(.horizontal)
        .frame(height: 80)
    }
    
    func bomc() {
        print("회원정보수정: \(viewModel.user.profileImageUrl)")
    }
}


