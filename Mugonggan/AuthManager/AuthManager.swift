//
//  AuthManager.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/20.
//

import Foundation
import FirebaseAuth

// 
// struct AuthDataResultModel {
//     
//     let email: String?
//     var name: String?
//     var password: String?
//     var uid: String
//     var profileImageUrl: String?
//     
//     init(user: User) {
//         self.email = user.email
//         self.name = user.name
//         self.password = user.password
//         self.uid = user.uid
//         self.profileImageUrl = user.profileImageUrl
//     }
//     
//     
//     final class AuthManager {
//         static let shared =
//         AuthManager()
//         private init() { }
//     
//         func getAuthUser() throws -> AuthDataResultModel {
//             guard let user = Auth.auth().currentUser else {
//                 throw
//                 URLError(.badServerResponse)
//             }
//             return AuthDataResultModel(user: user)
//         }
//     }
// }
