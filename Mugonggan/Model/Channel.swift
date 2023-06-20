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
    let bookmarkCount: Int
    let likeCount: Int
    let commentCount: Int
    let channelImageUrl: String
    let email: String
    let name: String
    let uid: String
    let timestamp : Timestamp
    let likeWho : LikeWho
}

let likeWho = LikeWho(likewho: [])

let MOCK_CHANNEL = Channel(id: "documentID",
                        bookmarkCount: 0,
                      likeCount:0,
                      commentCount: 0,
                      channelImageUrl: "https://firebasestorage.",
                      email: "test@gmail.com",
                      name: "usernickName",
                      uid: "Auth-register-uid",
                      timestamp: Timestamp(),
                        likeWho: likeWho
)

