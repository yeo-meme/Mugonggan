//
//  Owner.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/03.
//

import FirebaseFirestoreSwift

struct Owner: Identifiable, Decodable {
    @DocumentID var id: String?
    let email: String
    var name: String
    var password: String
    var uid: String
    var profileImageUrl: String
    //    var status: Status
}

let MOCK_OWNER = Owner(id: "000000",
                         email: "test@gmail.com",
                         name: "Username",
                         password: "000000",
                         uid: "111111111",
                         profileImageUrl: "Profile Url")
