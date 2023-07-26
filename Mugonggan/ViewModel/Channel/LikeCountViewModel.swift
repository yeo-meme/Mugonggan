//
//  LikeViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/09.
//


import Foundation
import FirebaseFirestore



class LikeCountViewModel: ObservableObject {
    
    @Published var channel = [Channel]()
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var imageUrl : String?
    
    var documentRef : DocumentReference?
    @Published var isFilled:Bool = false
    
    var user: UserInfo?
    var likeUser: [String]?
    
    func resetLikeUser() {
        self.likeUser = []
        self.channel = []
    }
    
    func addToLikeUser(_ name:String) {
        self.likeUser?.append(name)
    }
    
    // MARK: - LIKE UPDATE
    //who : 누가 좋아요를 눌렀는지
    func getChannel(_ imageUrl: String,_ isState:Bool,_ user : UserInfo?) {
        
        guard let userInfo = user else {
            return
        }
        
        resetLikeUser()
        self.user = userInfo
        var presentUid = ""
        
        let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: imageUrl)
        
        query.getDocuments { (snapshot, error) in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                print("error Msg : \(errorMessage)")
                return
            }
            
            guard let doc = snapshot?.documents else {return}
            
            for document in doc {
                let documentID = document.documentID
                presentUid = documentID // 업데이트도큐먼트아이디
                print("document data :\(document.data())")// 채널콜렉션 이미지의 도큐먼트 ID
            }
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
          
            //이미지정보
            for uidArr in self.channel {
                self.likeUser?.append(contentsOf: uidArr.likewho)
            }
            
            DispatchQueue.main.async { [self] in // 메인 스레드에서 실행되도록 변경
                if (isState) {
                    self.plusLikeCountUpdate(presentUid)
                } else {
                    self.miusUpdate(presentUid)
                }
            }
        }
        
    }
    
    func miusUpdate(_ uid:String) {
        
        //카운팅정보
        var operateCount=0
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        operateCount -= 1
        

        let userUid = self.user?.uid
        // self.likeUser?.removeAll{ $0 == userUid }
        
        if let indexToRemove = likeUser?.firstIndex(where: { $0 == userUid}) {
            likeUser?.remove(at: indexToRemove)
        }
        
        
        let data: [String: Any] = [
            KEY_LIKE_COUNT: operateCount,
            KEY_LIKE_WHO: self.likeUser
        ]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            }
        }
    }
    
    
    //uid 채널이미지 주인
    func plusLikeCountUpdate(_ uid:String) {
        
        var operateCount=0
        
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        //사용자 : 이름 , 프로필 사진 url , uid
        guard let likeUserUid = self.user?.uid else {return}
        addToLikeUser(likeUserUid)
        
        
        operateCount += 1
        let data: [String: Any] = [
            "likeCount": operateCount,
            KEY_LIKE_WHO: self.likeUser
        ]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
}
