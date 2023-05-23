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
                        
                        self.presentationMode.wrappedValue.dismiss()
                        fetchData()
                        //                        if checkSignUpCondition() {
                        //                            registerUser(email: email, password: password)
                        //                        } else {
                        //
                        //                        }
                        //
                        
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
        //        .background(Color.pink)
        //        .navigationViewStyle(StackNavigationViewStyle())
        
        
    }//: View
    
    
    private func saveUserToFirebase(_ uid: String, completion: @escaping (Bool) -> Void ) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document()
        
        userRef.setData([
            "name": uid
        ]) { error in
            if let error = error {
                print("Error Saving \(error.localizedDescription)")
                completion(false)
            } else {
                print("db 저장 성공")
                completion(true)
                //                showingSignUpView = false
                //
                //
                //                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func uploadUserInfo(_ uid: String) {
        if !uid.isEmpty {
            saveUserToFirebase(uid) { success in if success {
                print("회원가입 성공" + uid)
                //                DispatchQueue.global().async {
                //                    DispatchQueue.main.async {
                //                        showingSignUpView = false
                //                        guard let pvc = self.presentingViewController else {return}
                //                        self.dismiss(animated: true) {
                //                            pvc.present(MulistVIew(), animated: true, competion: nil)
                //                        }
                //                    }
                //                }
            } else {
                print("회원가입 성공못함 1")
            }
            }
        } else {
            print("회원가입 성공못함 2")
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
    
    func fetchData() {
        DispatchQueue.global().async {
            // 비동기적인 데이터 요청 등의 작업 수행
            
            DispatchQueue.main.async {
                // 메인 큐에서 UI 업데이트
                print("fetCh")
                isViewPresented = true
                presentationMode.wrappedValue.dismiss()
             
            }
        }
    }
    
    struct LogingView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView(isViewPresented: .constant(false))
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }
}


