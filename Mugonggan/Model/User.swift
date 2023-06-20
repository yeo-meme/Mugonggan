//
//  User.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/20.
//

import Foundation
import FirebaseAuth

// struct User {
//     let uid: String
//     let email: String?
//     let customData: CustomData
//     
//     init(user: User, customData: CustomData) {
//         self.uid = user.uid
//         self.email = user.email
//         self.customData = customData
//     }
// }
// 
// struct CustomData {
//     var name: String
//     var password: String
//     var profileImageUrl: String
// }
// 
// final class AuthenticationManager {
//     static let shared = AuthenticationManager()
//     private init() { }
//     
//     func getAuthenticationUser() throws -> CustomData {
//         guard let user = Auth.auth().currentUser else {
//             throw URLError(.badServerResponse)
//         }
//         
//         let customData = try await fetchUserFromFirestore(userId: user.uid)
//         
//         return User(user: user, customData: customData)
//     }
//     
//     func fetchUserFromFirestore(userId: String) async throws -> CustomData {
//         let docRef = COLLECTION_USERS.document(userId)
//         let docSnap = try await docRef.getDocument()
//         
//         guard let docData = docSnap.data(),
//               let name = docData[KEY_USERNAME] as? String,
//               let profileImg = docData[KEY_PROFILE_IMAGE_URL] as? String,
//                 let password = docData[KEY_PASSWORD] as? String else {
//             throw URLError(.badServerResponse)
//         }
//         
//         let customData = CustomData(name: name, password: password, profileImageUrl: profileImg)
//         return customData
//     }
// }
