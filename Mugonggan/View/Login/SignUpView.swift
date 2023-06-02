//
//  LogingView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore


struct SignUpView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    //View 컨텍스트에서 제공되는 환경 속성입니다. 이 속성은 현재 뷰가 표시되는 방식과 관련된 정보를 제공
    // 프로퍼티 래퍼는 구조체에서 사용될 때만 사용할 수 있습니다
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userData: UserData
    
    @Binding var isViewPresented :Bool
    
    @State private var email: String = ""
    @State private var password:String = ""
    @State private var name: String = ""
    
    @State private var isCompleteClose = false
    @State private var showAlert = false
    @State private var showingSignUpView = false
    
    
    
    var body: some View {
        
        
        NavigationView{
            VStack {
                NavigationLink(
                    destination: ProfilePhotoSelectorView() ,
                    isActive: $viewModel.didAuthenticateUser,
                    label: {})
                
                IntroParagraph(title1: "회원등록하고", title2: "무공간을 이용해보세요")
                    .padding(.horizontal, -10)
                    .padding(.top, 20)
                
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
                    
                    //: BUTTON 완료
                    Button(action: {
                        if checkSignUpCondition() {
                            viewModel.register(withEmail: email, name: name, password: password)
                        } else {
                            
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
                self.presentationMode.wrappedValue.dismiss()
            })
                                {
                Image(systemName: "xmark")
            }
            )
            .accentColor(Color.black)
        }//:NAVIGATIONVEIW
    }//: View
    
    
    private func checkSignUpCondition () -> Bool {
        if name.isEmpty ||  email.isEmpty || password.isEmpty {
            return false
        }
        return true
    }
    
    
    struct LogingView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView(isViewPresented: .constant(false))
                .environmentObject(AuthViewModel())
        }
    }
}


