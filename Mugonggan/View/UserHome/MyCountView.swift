//
//  MyCountView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

struct MyCountView: View {
    
    // @EnvironmentObject private var viewModel: AuthViewModel
    // @ObservedObject private var countViewModel: CountViewModel
    
    // init(_ user: UserInfo) {
    //     self.viewModel = EditProfileViewModel(user)
    // }
    
    
    // init(_ user: UserInfo) {
    //     self.countViewModel = CountViewModel(user)
    // }
    
    // init(countViewModel: CountViewModel) {
    //     _countViewModel = StateObject(wrappedValue: countViewModel)
    // }
    
    // ???: - wrappedValue 랑 변수선언 궁금해
    // init() {
    //     let viewModel = AuthViewModel()
    //     self._countViewModel = StateObject(wrappedValue: CountViewModel(authViewModel: viewModel))
    // }
    
    
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: -팔로우 팔로워
            VStack(spacing: 0){
                HStack{
                    Rectangle()
                        .stroke(Color.black)
                        .overlay(
                            HStack{
                                Text("팔로우")
                                Spacer()
                                Rectangle()
                                    .stroke(Color.black)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        Text("3")
                                            .font(.system(size: 15,weight: .semibold)))
                                    .background(Color("CountColor"))
                            }
                                .padding(.leading, 20)
                            
                        )
                        .frame(height: 50)
                        .background(Color("FollowColor"))
                        
                }
                
                HStack{
                    Rectangle()
                        .stroke(Color.black)
                        .overlay(
                            HStack{
                                Text("팔로워")
                                Spacer()
                                Rectangle()
                                    .stroke(Color.black)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        Text("3")
                                            .font(.system(size: 15,weight: .semibold)))
                                    .background(Color("CountColor"))
                            }
                                .padding(.leading, 20)
                            
                        )
                        .frame(height: 50)
                        .background(Color("FollowerColor"))
                }
            }
            .padding(.horizontal, 10)
            
            
            // MARK: - like,etc Banner
            HStack {
                HStack(spacing: 0){
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    // Text("\(countViewModel.totalLikes)")
                                                        // .font(.system(size: 15, weight: .semibold))
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        
                                        Text("좋아요")
                                            .font(.system(size: 13))
                                    }
                                    
                                    Image(systemName: "heart")
                                        .padding(.bottom,1)
                                        .frame(width: 30,height: 30)
                                    
                                }
                                    .padding()
                            )
                    }
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    // Text("\(countViewModel.totalBookmark)")
                                                    //     .font(.system(size: 15, weight: .semibold))
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        Text("북마크")
                                            .font(.system(size: 13))
                                    }
                                 
                                    Image(systemName: "bookmark")
                                        .padding(.bottom,1)
                                    
                                }
                                    .padding()
                            )
                    }
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .foregroundColor(Color.white)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    // Text("\(countViewModel.totalComments)")
                                                    //     .font(.system(size: 15, weight: .semibold))
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        Text("댓글")
                                            .font(.system(size: 13))
                                    }
                              
                                    Image(systemName: "message")
                                        .padding(.bottom,1)
                                    
                                }
                                    .padding()
                            )
                    }
                }
                .background(Color("CountColor"))
                .padding(.horizontal,10)
            }
        }
        // MARK: -View Model
        .onAppear{
            // countViewModel.fetchUser()
        }
    }
}
// 
// struct MyCountView_Previews: PreviewProvider {
//     static var previews: some View {
//         // !!!: 잔깐만..여기서 nil을 던지자너
//         // let countViewModel = CountViewModel(userSession: nil)
//         return MyCountView(AuthViewModel.shared.currentUser)
//     }
// }
