//
//  ImageUploader.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, folderName: String,uid: String, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.0001) else { return }
        
//        let storageRef = Storage.storage().reference()
//                let imageRef = storageRef.child("images/image.jpg")
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(folderName)/\(uid)/\(filename)")
        
        print("file path: \(ref)")
        ref.putData(imageData, metadata: nil) { _, error in
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
