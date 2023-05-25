//
//  Constants.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/25.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_CHANNELS = Firestore.firestore().collection("channels")

let KEY_EMAIL = "email"
let KEY_USERNAME = "username"
let KEY_FULLNAME = "fullname"
let KEY_STATUS = "status"
let KEY_PROFILE_IMAGE_URL = "profileImageUrl"

let FOLDER_PROFILE_IMAGES = "profile_images"
let FOLDER_CHANNEL_IMAGES = "channel_images"