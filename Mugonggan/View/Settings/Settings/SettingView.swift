//
//  SettingView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var viewModel: EditProfileViewModel
    @State private var showSheet = false
    
    init(_ user: UserInfo) {
        self.viewModel = EditProfileViewModel(user)
        self.userViewModel = UserViewModel(user)
    }
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                NavigationLink(
                    destination: EditProfileView(viewModel),
                    label: { SettingsProfile(viewModel: userViewModel)
                    })
                
                
                VStack(spacing: 1) {
                    ForEach(SettingsCellViewModel.allCases, id: \.self) { viewModel  in
                        Button(action: {}, label: {
                            SettingsCell(viewModel: viewModel)
                        })
                    }
                }
                
                
                // MARK: - logout
                Button(action: { self.showSheet = true },
                       label: { Text("Log out").font(.system(size: 18, weight: .semibold)) }
                )
                .foregroundColor(.red)
                .font(.system(size: 18))
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .background(Color.white)
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Log out"),
                                message: Text("로그아웃 하시면 자동로그인 풀려서 다시 로그인하셔야 해요"),
                                buttons: [
                                    .destructive(Text("웅 로그아웃"), action: { AuthViewModel.shared.signOut() }),
                                    .cancel(Text("그건 귀찮은데")) ])
                }
                Spacer()
                
            }
        }
    }
}



