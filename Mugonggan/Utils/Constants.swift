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
let COLLECTION_CHANNELS_ZIP = Firestore.firestore().collection("channels_zip")
let COLLECTION_GROUP_CHANNELS_ZIP = Firestore.firestore().collectionGroup("channels_zip")



let KEY_ZIP = "zip"
let KEY_EMAIL = "email"
let KEY_USERNAME = "name"
let KEY_PASSWORD = "password"
let KEY_UID = "uid"
let KEY_PROFILE_IMAGE_URL = "profileImageUrl"
let KEY_CHANNEL_IMAGE_URL = "channelImageUrl"

let KEY_LIKE_COUNT = "likeCount"
let KEY_COMMENT_COUNT = "commentCount"

let FOLDER_PROFILE_IMAGES = "profile_images"
let FOLDER_CHANNEL_IMAGES = "channel_images"

let IMAGEURL = "gs://mugonggan-817e7.appspot.com/"
