//
//  MyCountView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

struct MyCountView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
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
                            }
                                .padding(.leading, 20)
                                
                        )
                        .frame(height: 50)
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
                            }
                                .padding(.leading, 20)
                                
                        )
                        .frame(height: 50)
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
                            .foregroundColor(Color.white)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    Image(systemName: "heart")
                                                        .padding(.bottom,1)
                                                }
                                            )
                                        Divider()
                                            .background(Color.black)
                                            Text("좋아요")
                                            .font(.system(size: 13))
                                    }
                                    Text("4")
                                        .font(.system(size: 40, weight: .semibold))
                                    
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
                                                    Image(systemName: "heart")
                                                        .padding(.bottom,1)
                                                }
                                            )
                                        Divider()
                                            .background(Color.black)
                                            Text("좋아요")
                                            .font(.system(size: 13))
                                    }
                                    Text("4")
                                        .font(.system(size: 40, weight: .semibold))
                                    
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
                                                    Image(systemName: "heart")
                                                        .padding(.bottom,1)
                                                }
                                            )
                                        Divider()
                                            .background(Color.black)
                                            Text("좋아요")
                                            .font(.system(size: 13))
                                    }
                                    Text("4")
                                        .font(.system(size: 40, weight: .semibold))
                                    
                                }
                                    .padding()
                            )
                    }
                }
                .padding(.horizontal,10)
                
//                Rectangle()
//                    .foregroundColor(Color.white)
//                    .frame(width: .infinity, height: 100)
//                    .overlay(
//
//                    )
            }
        }
    }
}

struct MyCountView_Previews: PreviewProvider {
    static var previews: some View {
        MyCountView()
    }
}
