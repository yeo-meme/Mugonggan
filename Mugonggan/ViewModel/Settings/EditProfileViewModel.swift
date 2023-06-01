//
//  EditProfileViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import UIKit
import Firebase
import FirebaseStorage

class EditProfileViewModel: ObservableObject {
   
    @Published var user: UserInfo
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    //    @Published var selectedStatus:
    
    init(_ user: UserInfo) {
        self.user = user
    }
    
    func getButtonLabel(image: UIImage?, username: String) -> String {
        if (image != nil || username != user.name || username != "") {
            return "Done"
        }
        return ""
    }
    
    
    func updateProfile(image: UIImage?, username: String) {
        if let image = image {
            updateProfileImage(image)
        }
        if (username != "" && username != user.name) {
            updateUserName(username)
        }
    }
    
    func updateUserName(_ username: String) {
        guard let uid = user.id else {return}
        let data : [String: Any] = [KEY_USERNAME : username]
        
        COLLECTION_USERS.document(uid).updateData(data) { error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            self.user.name = username
        }
    }
    
    func updateProfileImage(_ image: UIImage) {
        guard let uid = user.id else {return}
        let storagePath = Storage.storage().reference(forURL: user.profileImageUrl)
        storagePath.delete { error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
        }
        
        ImageUploader.uploadImage(image: image, folderName: FOLDER_PROFILE_IMAGES, uid: uid) { imageUrl in
            let data: [String: Any] = [KEY_PROFILE_IMAGE_URL: imageUrl]
            COLLECTION_USERS.document(uid).updateData(data) { error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    return
                }
                self.user.profileImageUrl = imageUrl
            }
        }
    }
}
