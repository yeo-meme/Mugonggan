//
//  AuthViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import SwiftUI
import Firebase

class AuthViewModel: NSObject, ObservableObject {
    
    static let shared = AuthViewModel()
    
    override init() {
        super.init()
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
}


