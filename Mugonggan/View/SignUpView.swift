//
//  LogingView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
  
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password:String = ""
    @State private var name: String = ""
    
    @State private var isCompleteClose = false
    
    
    var body: some View {
        
        NavigationView{
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("email", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold, design: .default))
                    
                    SecureField("비밀번호", text:$password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold, design: .default))
                    
                    TextField("닉네임", text: $name)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold,
                                      design: .default))
                    
                    
                    Button(action: {
                        let result = registerUser(email: email, password: password, name: name)
                        
                        if result {
                            self.presentationMode.wrappedValue.dismiss()
                            print("회원가입 성공")
                        } else {
                            print("회원가입 성공못함")
                        }
                    }) {
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

private func registerUser(email: String, password: String, name: String) -> Bool {
    Auth.auth().createUser(withEmail: email, password: password) { (result, error)  in if let error = error {
        print("Error : \(error.localizedDescription)")
        return
    }
        guard let user = result?.user else {return}
        
//        let completeHandler:(User) -> Void = { user in
//            print(user.uid)
//        }
//        let userInfo = User(uid: user.uid)
//        completeHandler(userInfo)
      
    }
    return true
}

struct User {
    let uid: String

}

struct LogingView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
