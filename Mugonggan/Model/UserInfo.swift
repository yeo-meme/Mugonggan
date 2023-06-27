//
//  User.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/26.
//

import FirebaseFirestoreSwift

struct UserInfo: Identifiable, Decodable {
    @DocumentID var id: String?
    let email: String
    var name: String
    var password: String
    var uid: String
    var profileImageUrl: String
    //    var status: Status
}

let MOCK_USER = UserInfo(id: "default:000000",
                         email: "default:test@gmail.com",
                         name: "default:Username",
                         password: "default:000000",
                         uid: "default:111111111",
                         profileImageUrl: "default:Profile Url")

