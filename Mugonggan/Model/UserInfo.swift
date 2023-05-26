//
//  User.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/26.
//

import FirebaseFirestoreSwift

struct UserInfo: Identifiable {
    @DocumentID var id: String?
    let email: String
    var name: String
    var password: String
    var uid: String

}
