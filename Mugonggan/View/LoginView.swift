//
//  LoginView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var isEmailEditing: Bool = false
    @State private var isPwEditing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading, spacing: 30){
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("무공간")
                            .font(.system(size: 50, weight: .bold, design: .default))
                        Spacer()
                    }
                
                    TextField("email",text: $email, onEditingChanged: { editing in isEmailEditing = editing }
                    )
                        .padding()
                        .background(Color(UIColor.black))
                        .foregroundColor(.white)
                        .overlay(
                        Text("email")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(isEmailEditing ? .black : .white )
                            .opacity(email.isEmpty ? 1 : 0)
                            .font(.system(size: 24, weight: .bold,
                                          design: .default))
                            .padding(.leading,20)
                        )
                        .cornerRadius(9)
                    
                    
                    TextField("비밀번호", text: $password, onEditingChanged: {editing in
                        isPwEditing = editing})
                    .padding()
                    .background(Color(UIColor.black))
                    .foregroundColor(.white)
                    .overlay(
                    Text("비밀번호")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(isPwEditing ? .black : .white)
                        .opacity(password.isEmpty ? 1 : 0)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding(.leading, 20)
                    )
                    .cornerRadius(9)
                    
                       
                    VStack {
                        HStack(spacing: 60){
                            Text("로그인")
                            Text("회원가입")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    }
//                    .background(Color.pink)
                    .cornerRadius(9)
                    
                    Spacer()
                 
                }
                .padding(.horizontal)
                .padding(.top, -120)
//                .background(Color.green)
                
                Spacer()
            }
//            .navigationBarTitle("무공간", displayMode: .large)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    HStack {
//                        Spacer()
//                        Text("무공간")
//                            .font(.system(size: 36, weight: .bold, design: .default))
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        Spacer()
//                    }
//                }
//
//            }
//            .background(Color.pink)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
