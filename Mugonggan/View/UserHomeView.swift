//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI

struct UserHomeView: View {
    
    @Binding var muListLinkActive : Bool
    
    var body: some View {
     
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    muListLinkActive = false
                },label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .foregroundColor(.purple)
                    .padding(.trailing,30)
                })
            }
            HStack{
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 50,height: 50)
                    .foregroundColor(.purple)

                VStack{
                    Text("먀아아아아아")
                    Text("유저홈이다 뭐가필요해")
                }
              
               
                HStack{
                    Text("팔로우하삼")
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 50)
                .background(.purple)
                .cornerRadius(10)
                
            }
            .padding(.top, 30)
            
            
            Spacer()
        }
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView(muListLinkActive: .constant(true))
    }
}
