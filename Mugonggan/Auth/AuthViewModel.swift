//
//  AuthViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI
import FirebaseFirestore
import Firebase

class AuthViewModel: NSObject, ObservableObject {
    
    static let shared = AuthViewModel()
    @Published var userSession: FirebaseAuth.User?
//    @Published var currentUser: UserInfo?

    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    
    override init() {
        super.init()
    }

    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let (errorMessage) = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            

            print("snap get : \(snapshot?.data())")
//            guard let user = try? snapshot?.data(as: UserInfo.self) else { return }
//            self.currentUser = user
        }
    }
    
    func login(withEmail email: String, password: String) {
        self.errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let (errorMessage) = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
                        
            guard let user = result?.user else { return }
            self.userSession = user
//            self.fetchUser()
            guard let uid = self.userSession?.uid else {return}
            print("login userSession : \(uid)")
            
            self.fetchUser()
        }
    }
    
    func uploadProfileImage(_ image: UIImage,completion: @escaping(Bool) -> Void) {
        ImageUploader.uploadImage(image: image, folderName: FOLDER_PROFILE_IMAGES) { imageUrl in
            let data: [String: Any] = [KEY_PROFILE_IMAGE_URL : imageUrl]
            
            let db = Firestore.firestore()
            let userRef = db.collection("photo").document()
            
            userRef.setData([
                "photoUrl": data
                
            ]) { error in
                if let error = error {
                    print("Error Saving \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("사진 db 저장 성공")
                    completion(true)
                }
            }
            //            COLLECTION_USERS.ducument(uid).updateData(data) { error in
            //                if let errorMessage = error?.localizedDescription {
            //                    print("errror \(errorMessage)")
            //                    return
            //                }
            //            }
        }
    }
    
    
    func register(withEmail email: String, name: String,password: String) {
        self.errorMessage = ""
        var createUid: String = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let (errorMessage) = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let user = result?.user else { return }
//            self.tempCurrentUser = user
//            self.tempCurrentUsername = name
//            userSession = user
             createUid = String(user.uid)
            
            let data: [String: Any] = [KEY_EMAIL: email,
                                       KEY_USERNAME: name,
                                       KEY_PASSWORD: password,
                                         KEY_UID: createUid
            ]
            
            COLLECTION_USERS.document(user.uid).setData(data) { error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    return
                }
//                self.didAuthenticateUser = true
            }
        }
    }
    
    
}


