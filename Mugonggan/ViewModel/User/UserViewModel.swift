//
//  UserViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import UIKit
import Firebase
import FirebaseStorage

class UserViewModel: ObservableObject {
    @Published var user: UserInfo
    @Published var showErrorAlert = false
    @Published var erroMessage = ""
    
    init(_ user: UserInfo) {
        self.user = user
    }
    
    
}
