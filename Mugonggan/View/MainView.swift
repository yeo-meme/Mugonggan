//
//  LoginView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    
    @State private var isSignInCompleteView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject private var userData: UserData
    
    @State private var email:String = ""
    @State private var password:String = ""
    
    @State private var isEmailEditing: Bool = false
    @State private var isPwEditing: Bool = false
    
    
    @State private var showingSignUpView: Bool = false
    @State private var isViewPresented = false
    //swiftUI
    
    var body: some View {
        
        NavigationView {
            VStack {
                if isViewPresented {
                    MulistView()
                } else {
                    LoginView()
                }
            }
        }//:NAVIGATION
        
    }//:VIEW BODY
    
}//:VIEW

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
