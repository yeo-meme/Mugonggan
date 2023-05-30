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
    
    @Published var didAuthenticateUser = false
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserInfo?
    
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    
    private var tempCurrentUser: Firebase.User?
    var tempCurrentUsername = ""
    
    
    static let shared = AuthViewModel()
    
    override init() {
        super.init()
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let (errorMessage) = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let user = try? snapshot?.data(as: UserInfo.self) else { return }
            self.currentUser = user
            
            print("currentUser:\(self.currentUser) / userSession: \(self.userSession)")
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
            guard let uid = self.userSession?.uid else {return}
            print("login userSession : \(uid)")
            
            self.fetchUser()
        }
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping(Bool) -> Void) {
        guard let uid = tempCurrentUser?.uid else {return}
        
        ImageUploader.uploadImage(image: image, folderName: FOLDER_PROFILE_IMAGES) { imageUrl in
            let data: [String: Any] = [KEY_PROFILE_IMAGE_URL : imageUrl]
            
        print("data : \(data)")
            COLLECTION_USERS.document(uid).updateData(data) { error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    print("errror \(errorMessage)")
                    completion(false)
                    return
                }
            }
            
            self.currentUser?.profileImageUrl = imageUrl
            self.userSession = Auth.auth().currentUser
            self.fetchUser()
        }
    }
    
    //CHANNEL
    func uploadChannelImage(_ image: UIImage, completion: @escaping(Bool) -> Void) {
        guard let uid = currentUser?.uid else { return }
      
        ImageUploader.uploadImage(image: image, folderName: FOLDER_CHANNEL_IMAGES) { imageUrl in
            let data: [String: Any] = [KEY_CHANNEL_IMAGE_URL : imageUrl]
            
            COLLECTION_CHANNELS.document(uid).setData(data) { error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    completion(false)
                    return
                }
            }
            
            self.currentUser?.profileImageUrl = imageUrl
            self.userSession = Auth.auth().currentUser
            self.fetchUser()
            completion(true)
        }
    }
    
    
    func test(_ image: UIImage) {
        print("왜 안읽히냐 \(image)")
    }
    func signOut() {
        self.didAuthenticateUser = false
        self.currentUser = nil
        self.userSession = nil
        self.tempCurrentUser = nil
        try? Auth.auth().signOut()
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
            self.tempCurrentUser = user
            self.tempCurrentUsername = name
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
                self.didAuthenticateUser = true
            }
        }
    }
    
    
}


