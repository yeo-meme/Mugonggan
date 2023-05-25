//
//  ContentView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/18.
//

import SwiftUI
import CoreData
import FirebaseCore
import FirebaseFirestore


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var userData = UserData()
        @State private var showingSignUpView = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            
            LoginView()
//            if showingSignUpView {
//                MulistView()
//            } else {
//                MainView()
//            }
        }
      
        .onAppear{
            print("where: contentView")}
            .onReceive(userData.$isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    showingSignUpView = false
                }
            }
           
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AuthViewModel())
    }
}
