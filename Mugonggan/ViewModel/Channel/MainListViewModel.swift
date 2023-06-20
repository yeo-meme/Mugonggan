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
    @Published var channel : [ Channel] = []
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    
    init() {
        // fetch()
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
    
    
    
    func getLikeDocument() {
        
        let userId = AuthViewModel.shared.currentUser
        
        guard let userId = AuthViewModel.shared.currentUser?.uid else { return}
        
        let docRef = COLLECTION_CHANNELS.document(userId).collection("SUB")
        
       
        docRef.getDocuments{ snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.channel = documents.compactMap({ try? $0.data(as: Channel.self)})
        }
        print("likewho \(channel)")
        // docRef.getDocument { (document, error) in
        //         if let likewhoArray = document.data()?["likewho"] as? [String] {
        //
        //             print("like who: \(likewhoArray)")
        //             // let likewho = LikeWho(likewho: likewhoArray)
        //         } else {
        //             print("likewho 값이 존재하지 않거나 유효하지 않습니다.")
        //     }
        // }
        
        
    }
    func fetch() {
        guard let currentUserId = AuthViewModel.shared.currentUser?.uid else {return}
        
        print("main fetch USer : \(currentUserId)")
        
        COLLECTION_CHANNELS_ZIP.getDocuments() { (snapshot, error) in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            
            for document in snapshot!.documents {
                // print("\(document.documentID) => \(channel)")
                // 데이터를 모델에 저장하는 로직을 추가
                // self.channels.append(channel)
                
            }
            
            guard let doc = snapshot?.documents else { return }
            self.channel = doc.compactMap({ try? $0.data(as: Channel.self) })
            print("모두 다 불러와 \(self.channel)")
            
        }
    }
}
