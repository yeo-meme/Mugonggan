//
//  MainListViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/15.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class MainListViewModel: ObservableObject {
    
    // ???: let 변수선언과 Published 선언의 차이점을 잘모르겠네
    @Published var channel = [ChannelZip]()
    @Published var likewho = [LikeWho]()
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    @Published var user: UserInfo
    
    
    // TODO:
    //1. 로드시 channel의 모든데이터 불러오기
    //
    init(_ user: UserInfo) {
        self.user = user
        GetCollectionChannelZip()
        // GetDocumentTest()
    }
    
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
        
        let userId = user.uid
        
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
        
        // let userId = AuthViewModel.shared.currentUser
        // guard let userId = AuthViewModel.shared.currentUser?.uid else { return}
        
        let uid = user.uid
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
                let likeWhoSnap = documents.compactMap({ try? $0.data(as: LikeWho.self)})
                self.likewho = likeWhoSnap
                print("MainListViewModel/ likewho \(self.likewho)")
            } catch {
                print("error like who: \(error)")
            }
            
        }
        
        
    }
    
    
    
    // 콜렉션 도큐먼트 call test
    func GetCollectionChannelZip() {
        
        print("user in : \(user.uid)")
        COLLECTION_CHANNELS_ZIP.getDocuments { snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let channelTest = documents
                .compactMap({ try? $0.data(as: ChannelZip.self) })
            
            
            self.channel = channelTest
            print("변환해 \(self.channel)")
        }
    }
}
