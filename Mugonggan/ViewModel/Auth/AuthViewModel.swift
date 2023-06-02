//
//  AuthViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import Foundation

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
        
        ImageUploader.uploadImage(image: image, folderName: FOLDER_PROFILE_IMAGES, uid: uid) { imageUrl in
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
    
    
    func dateFormatter() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeString = dateFormatter.string(from: currentTime)
        
        return currentTimeString
    }
    
    
    // MARK: - CHANNEL IMAGE UPLOAD
    func uploadChannelImage(_ image: UIImage, completion: @escaping(Bool) -> Void) {
        guard let uid = currentUser?.uid else { return }
        guard let email = currentUser?.email else { return }
        guard let name = currentUser?.name else { return }
        let likeCount = "2"
        let bookmarkCount = "3"
        let commentCount = "0"
        let currentTime = Timestamp()
        
        let collection_dc_add = COLLECTION_CHANNELS.document(uid)
        let subCollection = collection_dc_add.collection("SUB").document()
        
        ImageUploader.uploadImage(image: image, folderName: FOLDER_CHANNEL_IMAGES,uid: uid) { imageUrl in
            
            let data: [String: Any] = [
                KEY_CHANNEL_IMAGE_URL : imageUrl,
                "uid":uid,
                "email":email,
                "name":name,
                "likeCount":likeCount,
                "bookmarkCount":bookmarkCount,
                "commentCount":commentCount,
                "timestamp": currentTime
            ]
            
      
            
            COLLECTION_CHANNELS_ZIP.addDocument(data: data) {error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    completion(false)
                    return
                }
            }
            
            subCollection.setData(data) { error in
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

