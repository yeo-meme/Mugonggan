//
//  MainListViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/15.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ChannelListViewModel: ObservableObject {
    
    // ???: let 변수선언과 Published 선언의 차이점을 잘모르겠네
    // @Published var channel = [ChannelZip]()
    // @Published var likewho = [LikeWho]()
    
    
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    @Published var user : UserInfo?
    @Published var channel : [Channel]?
    
    // TODO:
    //1. 로드시 channel의 모든데이터 불러오기
    //
    init() {
        guard let currentId = AuthViewModel.shared.currentUser else { return }
        self.user = currentId
        GetCollectionChannelZip()
    }
    
    // var channelImageUid : String {
    //     guard let channelPartner = channel else { return "" }
    //     return channelPartner.uid
    // }
    
    // func getAllWave() {
    //     Task{
    //         let auth = try AuthViewModel.shared.currentUser
    //         let userId = auth?.uid
    //         let userChannel = try? await UserManager.shared.getChannelDoc(userId: userId!)
    //
    //         var localArray: [Channel] = []
    //         for channelImg in channel {
    //             if let product = try? await UserManager.getChannelDoc(userId: String(userId!)) {
    //                 localArray.append((channel))
    //             }
    //         }
    //         self.channel = localArray
    //     }
    //     print("get wave : \(channel)")
    // }
    
    
    //Document get test
    func GetDocumentTest() {
        
        let userId = user?.uid
        
        print("문서만불러오기 id: \(userId)")
        
        COLLECTION_CHANNELS_ZIP.document("c2b1W8znOdgP2J00irTD").getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    //SUB 데이터출력 테스트
    func getLikeDocument() {
    
        guard let uid = user?.uid else {
            return
        }
        print("MainListViewModel/ get LikeViewModel : \(uid)")
        
        let query = COLLECTION_CHANNELS
            .document(uid).collection("SUB")
        
        
        query.getDocuments{ snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            print("변환전 like data : \(documents)")
            
            for document in documents {
                print("변환전 내용: \(document.data())")
            }
            
            do {
                //변환에러는 나지 않는데
                let likeWhoSnap = documents.compactMap({ try? $0.data(as: LikeWho.self)})
                // self.likewho = likeWhoSnap
                // print("MainListViewModel/ likewho \(self.likewho)")
            } catch {
                print("error like who: \(error)")
            }
            
        }
        
        
    }
    
    
    
    // Cannel All 도큐먼트 call
    func GetCollectionChannelZip() {
        
        COLLECTION_CHANNELS.getDocuments { snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let channelTemp = documents
                .compactMap({ try? $0.data(as: Channel.self) })
            
            
            self.channel = channelTemp
            // self.channel = channelTest
            print("Channel LIst VIewModel: 변환해 \(self.channel)")
        }
    }
    
    
    
    func miusUpdate() {
        // var newLike = 0
        // if let unwrappedChannel = channel {
        //    let likeCount = unwrappedChannel.likeCount
        //         newLike = likeCount-1
        //         print("existLike: \(likeCount)")
        //         print("newLike: \(newLike)")
        // } else{
        //     print("Failed to get channel")
        // }
        
        // let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
        // documentRef.updateData(data) { error in
        //     if let error = error {
        //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
        //     } else {
        //         print("도큐먼트 업데이트 성공")
        //     }
        // }
    }
    
    // MARK: - 좋아요 증가
    func likePlusUpdate() {
        var newLike = 0
        let userId = user?.uid
        
        
        
        // guard let unwrappedChannel = channel else {return}
        
        // let likeCount = channel.likeCount
        
            // newLike = likeCount+1
            // print("existLike: \(likeCount)")
            // print("newLike: \(newLike)")
            // 
        
        //
        // let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
        // documentRef.setData(data) { error in
        //     if let error = error {
        //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
        //     } else {
        //         print("도큐먼트 업데이트 성공")
        //     }
        // }
        //
        // let likeData: [String: Any] = ["likewho" : likeName ]
        // likeCollection.updateData(likeData) { error in
        //     if let error = error {
        //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
        //     } else {
        //         print("도큐먼트 업데이트 성공")
        //     }
        // }
    }
}
