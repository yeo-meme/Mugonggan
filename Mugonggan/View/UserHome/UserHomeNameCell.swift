//
//  UserHomeNameCell.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI
import Kingfisher

class UserHomeNameCell: ObservableObject {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Published var nickName: String
    
    init(_ viewModel: AuthViewModel) {
        self.nickName = viewModel.currentUser?.name ?? ""
    }
    
    var title: String {
            return nickName
        }
}

