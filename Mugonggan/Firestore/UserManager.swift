//
//  UserManager.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/19.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    static let shared = UserManager()
    private init() { }
    

    private let userCollection : CollectionReference =
    Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func getChannelDoc(userId: String) async throws -> Wave{
        try await COLLECTION_CHANNELS.document(userId).getDocument(as: Wave.self)
        // print("model get : \()" )
    }
    
}
