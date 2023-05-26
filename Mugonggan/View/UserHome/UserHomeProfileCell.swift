//
//  UserHomeProfileCell.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/26.
//

import SwiftUI
import Kingfisher

struct UserHomeProfileCell: View {
    
    var body: some View {
        let imageURL = "https://i.pinimg.com/564x/e9/b5/e2/e9b5e29ea71553178976e7866a72057c.jpg"
        VStack (spacing: 1) {
            HStack (spacing: 12){
                KFImage(URL(string: imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48,height: 48)
                    .clipShape(Circle())
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("user name")
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
