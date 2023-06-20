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
    // @Environment(\.managedObjectContext) private var viewContext
    // @StateObject private var userData = UserData()
    // @State private var showingSignUpView = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    
    var body: some View {
        Group {
            if (viewModel.userSession != nil) {
                MainWaveImageList()
            } else{
                LoginView()
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            // .environmentObject(AuthViewModel())
    }
}
