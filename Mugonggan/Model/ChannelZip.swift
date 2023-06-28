//
//  ChannelZip.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/28.
//

import FirebaseFirestoreSwift
import Firebase

struct ChannelZip : Decodable {
    let bookmarkCount: Int
    let likeCount: Int
    let commentCount: Int
    let channelImageUrl: String
    let email: String
    let name: String
    let uid: String
    let timestamp : Timestamp
}
