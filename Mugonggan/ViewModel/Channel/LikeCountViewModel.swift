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
    
    
    // MARK: - LIKE UPDATE
    func getChannel(_ imageUrl: String,_ isState:Bool) {
        
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
                presentUid = documentID
                print("presentUid :\(presentUid)")// 채널콜렉션 이미지의 도큐먼트 ID
            }
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
            
            DispatchQueue.main.async { // 메인 스레드에서 실행되도록 변경
                if (isState) {
                    self.plusLikeCountUpdate(presentUid)
                } else {
                    self.miusUpdate(presentUid)
                }
            }
            
        }
    }
    
    func miusUpdate(_ uid:String) {
        
        var operateCount=0
        
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        operateCount -= 1
        let data: [String: Any] = [KEY_LIKE_COUNT: operateCount]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            }
        }
    }
    
    func plusLikeCountUpdate(_ uid:String) {
        
        var operateCount=0
        
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        operateCount += 1
        let data: [String: Int] = [
            "likeCount": operateCount,
        ]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
}
