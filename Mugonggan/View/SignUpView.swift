//
//  LogingView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI

struct SignUpView: View {
    
  
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password:String = ""
    @State private var name: String = ""
    
    var body: some View {
        
        
        
        NavigationView{
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("email", text: $email)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold, design: .default))
                    
                    SecureField("비밀번호", text:$password)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold, design: .default))
                    
                    TextField("닉네임", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold,
                                      design: .default))
                    
                    
                    Button(action: {}) {
                        Text("회원가입 완료")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(9)
                            
                    }//: 회원가입 완료버튼 BUTTON
                }//:VSTACK
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
              
            }//:VSTACK
            .navigationBarTitle("회원가입", displayMode: .inline)
            .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()           }){
                Image(systemName: "xmark")
            }
            )
            .accentColor(Color.black)
            
        }//:NAVIGATIONVEIW
        .background(Color.pink)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LogingView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
