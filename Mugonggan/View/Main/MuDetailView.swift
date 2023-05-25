//
//  MuDetailView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/23.
//

import SwiftUI

struct MuDetailView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var muListLinkActive:Bool
    var body: some View {

        VStack {
            HStack{
                NavigationLink(destination: UserHomeView(muListLinkActive: $muListLinkActive)) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.purple)
                    .frame(width: 70,height: 70, alignment: .center)
                }
                
                VStack{
                    Text("먀먀먀용")
                    Text("언제올렸냐야아아ㅏㅇ")
                }
                Button(action: {}) {
                    Text("팔로우")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fit)
            .padding()
            
            HStack() {
                Text("좋아요")
                    .foregroundColor(.white)
                Text("즐겨찾기")
                    .foregroundColor(.white)
                Text("댓글")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 70)
            .background(Color.purple)
            .padding()
            .cornerRadius(10)
        }
        
    }
}

struct MuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MuDetailView(muListLinkActive: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
