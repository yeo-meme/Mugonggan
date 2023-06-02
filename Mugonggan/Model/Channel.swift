//
//  UserHome.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import FirebaseFirestoreSwift
import Firebase

struct Channel: Identifiable, Decodable {
    @DocumentID var id: String?
    let bookmarkCount: String
    let likeCount: String
    let commentCount: String
    let channelImageUrl: String
    let email: String
    let name: String
    let uid: String
    let timestamp : Timestamp
}
let MOCK_CHANNEL = Channel(id: "documentID",
                        bookmarkCount: "00",
                      likeCount: "00",
                      commentCount: "00",
                      channelImageUrl: "https://firebasestorage.",
                      email: "test@gmail.com",
                      name: "usernickName",
                      uid: "Auth-register-uid",
                      timestamp: Timestamp())
