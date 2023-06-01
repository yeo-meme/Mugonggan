//
//  UserHomeProfileCell.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/26.
//

import SwiftUI
import Kingfisher

struct UserHomeProfileCell: View {

//    @ObservedObject var viewModel: AuthViewModel
//    @ObservedObject var userViewModel: UserViewModel
    @EnvironmentObject var viewModel: AuthViewModel
   
    
    var body: some View {
//        guard let imageURL =
        VStack (spacing: 1) {
            HStack (spacing: 12){
                KFImage(URL(string:viewModel.currentUser!.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48,height: 48)
                    .clipShape(Circle())
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.currentUser!.name)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("user 상태 제목")
                        .foregroundColor(Color(.systemGray))
                }
                
                Spacer()
            }
            .frame(height: 70)
            .background(Color.white)
            
            CustomDivider(leadingSpace: 76)
        }
    }
}

struct UserHomeProfileCell_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeProfileCell()
    }
}
