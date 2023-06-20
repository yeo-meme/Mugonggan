//
//  LikeViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/09.
//

//모듈
// Swift의 기본 프레임워크로, 문자열 처리, 날짜 및 시간, 파일 및 디렉터리 작업, 네트워킹 등과 같은 핵심적인 기능을 제공
import Foundation //String, Date, URL, Data //Swift의 핵심적인 기능을 제공
import FirebaseFirestore
// import UIKit-: UI 컴포넌트 및 기능을 사용할 수 있습니다. 예를 들어, UIView, UIButton, UILabel, UIImage 등과 같은 UI 요소/  iOS 앱 개발을 위한 UI 프레임워크입니다

class LikeViewModel: ObservableObject {
  
    @Published var channel: Channel?
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var imageUrl : String?
    var documentRef : DocumentReference?
    @Published var isFilled:Bool = false

    
    init(_ imageUrl: String, isFiiled: Bool) {
        self.imageUrl = imageUrl
        self.isFilled = isFiiled
        self.getChannel()
    }
    

    
    // MARK: - LIKE UPDATE
    func getChannel() {
        guard let url = imageUrl else { return }
        let query = COLLECTION_CHANNELS_ZIP.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: url)
        
      
        
        query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("도큐먼트 검색 에러: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("검색 결과가 없습니다.")
                    return
                }
                
                for document in documents {
                    self.documentRef = COLLECTION_CHANNELS_ZIP.document(document.documentID)
                    
                    guard let channel = try? document.data(as: Channel.self) else { return }
                    self.channel = channel
                }
            
            
            guard let docRef = self.documentRef else {return}
          
            let likeCollection = COLLECTION_CHANNELS_ZIP.document(self.channel!.uid).collection("SUB").document("likewho")
            
            if self.isFilled {
                self.likePlusUpdate(docRef,likeCollection: likeCollection)
            } else {
                self.miusUpdate(docRef)
            }
        }
    }
    
    func miusUpdate(_ documentRef:DocumentReference) {
        var newLike = 0
        if let unwrappedChannel = channel {
           let likeCount = unwrappedChannel.likeCount
                newLike = likeCount-1
                print("existLike: \(likeCount)")
                print("newLike: \(newLike)")
        } else{
            print("Failed to get channel")
        }
        
        let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
        documentRef.updateData(data) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            } else {
                print("도큐먼트 업데이트 성공")
            }
        }
    }
    
    // MARK: - 좋아요 증가
    func likePlusUpdate(_ documentRef:DocumentReference, likeCollection: DocumentReference) {
        var newLike = 0
        print("like 플러스 인")
        
        var likeName = AuthViewModel.shared.currentUser?.uid
        
        print("like 이름 \(likeName)")
        
        if let unwrappedChannel = channel {
            let likeCount = unwrappedChannel.likeCount
                newLike = likeCount+1
                print("existLike: \(likeCount)")
                print("newLike: \(newLike)")
            
            
            } else {
                print("Failed to get channel")
        }
        
        let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
        documentRef.setData(data) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            } else {
                print("도큐먼트 업데이트 성공")
            }
        }
        
        let likeData: [String: Any] = ["likewho" : likeName ]
        likeCollection.updateData(likeData) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            } else {
                print("도큐먼트 업데이트 성공")
            }
        }
    }
    
    
    // func getChannel() {
    //     guard let url = url else { return }
    //     let query = COLLECTION_CHANNELS_ZIP.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: url)
    //
    //     query.getDocuments{ (snapshot, error) in
    //         if let error = error {
    //             print("도큐먼트 검색 에러: \(error.localizedDescription)")
    //         }
    //         guard let documents = snapshot?.documents else {
    //             print("검색 결과가 없습니다.")
    //             return
    //         }
    //
    //
    //
    //         for document in documents {
    //             let documentRef = COLLECTION_CHANNELS_ZIP.document(document.documentID)
    //
    //             let channel = document.data(as: Channel.self)
    //
    //             var newLike = ""
    //             if let likeCount = Int(channel.likeCount) {
    //                 newLike = String(likeCount + 1)
    //                 print("existLike : \(likeCount)")
    //                 print("newLike: \(newLike)")
    //             } else {
    //                 print("Failed to convert likeCount to an integer")
    //             }
    //
    //             let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
    //
    //
    //             try documentRef.updateData(data){ error in
    //                 if let error = error {
    //                     print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
    //                 } else {
    //                     print("도큐먼트 업데이트 성공")
    //                 }
    //             }
    //         }
    //     }
    // }
    
    //
    // func updateChannelLike() {
    //
    //
    //     let data: [String: Any] = [KEY_LIKE_COUNT: 3]
    //     COLLECTION_CHANNELS_ZIP.document(uid).updateData(data) { error in
    //         if let errorMessage = error?.localizedDescription {
    //             self.showErrorAlert = true
    //             self.errorMessage = errorMessage
    //             return
    //         }
    //     }
    //
    //     // }
    //
    //     // }
    // }
    
}
