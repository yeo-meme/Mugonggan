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
}
