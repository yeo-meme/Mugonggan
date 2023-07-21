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
import Foundation


struct ContentView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var body: some View {
        Group {
            if (viewModel.userSession != nil) {
                ChannelImageListView()
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
