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


struct User {
    
    let uid: String
    var email: String
    var name: String
    var password: String
    
    init(uid: String, email: String, name: String, password: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.password = password
    }
    
}

struct SignUpView: View {
    

    //View 컨텍스트에서 제공되는 환경 속성입니다. 이 속성은 현재 뷰가 표시되는 방식과 관련된 정보를 제공
    // 프로퍼티 래퍼는 구조체에서 사용될 때만 사용할 수 있습니다
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password:String = ""
    @State private var name: String = ""
    
    @State private var isCompleteClose = false
    @State private var showAlert = false
    
    
    
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
                    
                    //: BUTTON 완료
                    Button(action: {
                        
                        if checkSignUpCondition() {
                            registerUser(email: email, password: password)
                        } else {
                            
                            //                            Alert(title: Text("안녕"),
                            //                            message: Text("필수항목을 모두 입력해주세요"),
                            //                                  dismissButton: .default(Text("OK")))
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
    
    private func saveUserToFirebase(uid: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document()
        
        userRef.setData([
            "name": uid
        ]) { error in
            if let error = error {
                print("Error Saving \(error.localizedDescription)")
            } else {
                print("db 저장 성공")
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func uploadUserInfo(_ uid: String) -> Void {
        if !uid.isEmpty {
            saveUserToFirebase(uid: uid)
            print("회원가입 성공" + uid)
        } else {
            print("회원가입 성공못함")
        }
    }
    
    private func checkSignUpCondition () -> Bool {
        if name.isEmpty ||  email.isEmpty || password.isEmpty {
            return false
        }
        return true
    }
    
    private func registerUser(email: String, password: String) -> Void {
        var createUid: String = ""
        Auth.auth().createUser(withEmail: email, password: password) { (result, error)  in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {return}
            
            createUid = String(user.uid)
            print("createUid" + createUid)
            uploadUserInfo(createUid)
        }
    }
}


struct LogingView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
