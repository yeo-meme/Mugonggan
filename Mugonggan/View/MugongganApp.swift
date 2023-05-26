//
//  MugongganApp.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore


class UserData: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

@main
struct MugongganApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @StateObject private var userData = UserData()
    @State private var showingSignUpView = false
    
    init() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
    }

    
    var body: some Scene {
        WindowGroup {
//            if showingSignUpView {
//                SignUpView().environment(\.managedObjectContext, persistenceController.container.viewContext)
//            } else {
//                ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
//                .onReceive(userData.$isLoggedIn) { isLoggedIn in
//                if isLoggedIn {
//                    showingSignUpView = false
//                }
//            }
            
          

            ContentView()
                .environmentObject(userData)
                .environmentObject(AuthViewModel.shared)
        }
        
    }
}
