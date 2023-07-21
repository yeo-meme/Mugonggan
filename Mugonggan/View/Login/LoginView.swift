//
//  LoginView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // @EnvironmentObject private var userData: UserData
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var isLoggedIn : Bool = false
    
    @State private var isEmailEditing: Bool = false
    @State private var isPwEditing: Bool = false
    
    @State private var showingSignUpView: Bool = false
    @State private var isViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading, spacing: 30){
                    Spacer()
                    
                    IntroParagraph(title1: "어서오세요", title2: "무공간입니다")
                    
                    
                    TextField("email",text: $email, onEditingChanged: { editing in isEmailEditing = editing }
                    )
                    .padding()
                    .autocapitalization(.none)
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
                    .autocapitalization(.none)
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
                    
                    
                    VStack(spacing: 20){
                        HStack(){
                            Button(action: {
                                viewModel.login(withEmail: email, password: password)
                            })
                            {
                                Text("로그인")
                            }
                            .frame(width: 100, height: 70)
                         
                            
                            Button(action: {
                                // userData.isLoggedIn = false
                                self.showingSignUpView.toggle()
                                
                            }) {
                                Text("회원가입")
                            }
                            .frame(width: 100, height: 70)
                            
                        }//:HSTACK
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    }
                    .cornerRadius(9)
                    Spacer()
                    
                }//:VSTACK
                .padding(.horizontal)
                .padding(.top, -120)
                
                Spacer()
            }//: VStack
            .sheet(isPresented: $showingSignUpView) {
                SignUpView(isViewPresented: $isViewPresented).environment(\.managedObjectContext, self.managedObjectContext)
                    // .onDisappear{
                    //     if isViewPresented {
                    //         DispatchQueue.main.async {
                    //             let newView = MainWaveImageView(viewModel.currentUser!)
                    //             let hostingVC = UIHostingController(rootView: newView)
                    //
                    //             if let window = UIApplication.shared.windows.first {
                    //
                    //                 window.rootViewController = hostingVC
                    //                 window.makeKeyAndVisible()
                    //             }
                    //         }
                    //         print("isViewPresented true")
                    //     } else {
                    //         print("isViewPresented false")
                    //     }
                    // }
            }
        }
    }//: BODY VIEW
    
    
    // func login() {
    //     
    //     let success = true
    //     Auth.auth().signIn(withEmail: email ,password: password) { result, error in
    //         if let error = error {
    //             print("로그인 실패")
    //         } else {
    //             self.isLoggedIn.toggle()
    //             if isLoggedIn {
    //                 DispatchQueue.main.async {
    //                     let newView = MulistView().environmentObject(viewModel)
    //                     let hostingVC = UIHostingController(rootView: newView)
    //                     
    //                     if let window = UIApplication.shared.windows.first {
    //                         window.rootViewController = hostingVC
    //                         window.makeKeyAndVisible()
    //                     }
    //                 }
    //                 print("isLoggedIn true")
    //             } else {
    //                 print("isLoggedIn false")
    //             }
    //             
    //         }
    //     }
    // }
}//:VIEW

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
