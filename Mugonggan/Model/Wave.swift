//
//  Wave.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/19.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Wave: Codable {
    let bookmarkCount: Int
    let likeCount: Int
    let commentCount: Int
    let channelImageUrl: String
    let email: String
    let name: String
    let uid: String
    let timestamp : Timestamp
    
    enum CodingKeys: String, CodingKey {
        case bookmarkCount = "bookmarkCount"
        case likeCount = "likeCount"
        case commentCount = "commentCount"
        case channelImageUrl = "channelImageUrl"
        case email = "email"
        case name = "name"
        case uid = "uid"
        case timestamp = "timestamp"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bookmarkCount = try container.decode(Int.self, forKey: .bookmarkCount)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.channelImageUrl = try container.decode(String.self, forKey: .channelImageUrl)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.bookmarkCount, forKey: .bookmarkCount)
        try container.encode(self.likeCount, forKey: .likeCount)
        try container.encode(self.commentCount, forKey: .commentCount)
        try container.encode(self.channelImageUrl, forKey: .channelImageUrl)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.uid, forKey: .uid)
        try container.encode(self.timestamp, forKey: .timestamp)
    }
}
