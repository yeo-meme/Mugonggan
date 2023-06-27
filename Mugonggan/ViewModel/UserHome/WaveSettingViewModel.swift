//
//  UserHomeViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import Firebase
import Combine


// MARK: - DETAIL VIEW CALL MODEL
class WaveSettingViewModel: ObservableObject {
    
    @Published var user: UserInfo
    
    @Published var channel = [Channel]()
    @Published var likewho = [LikeWho]()

    
    init(_ user: UserInfo) {
        self.user = user
    }
    
    func getLikeDocument() {
        
        let userId = user.uid
    
        print("WaveSettingViewModel userId : \(userId)")
        
        // var userId = ""
        // do {
        //     userId = AuthViewModel.shared.currentUser?.uid ?? ""
        //     print("get LikeViewModel : \(userId)")
        // } catch {
        //     print("userId = userId?.ui is nil")
        // }
        //
        let query = COLLECTION_CHANNELS
            .document(userId).collection("SUB")
        
       
        query.getDocuments{ snapshot, error in
            if let errorMessage = error?.localizedDescription {
                // self.showErrorAlert = true
                // self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.likewho = documents.compactMap({ try? $0.data(as: LikeWho.self)})
        }
        print("WaveSettingViewModel: likewho \(likewho)")
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
    
    // init(userHome: [Channel] = [Channel]()) {
    //     self.userHome = userHome
    // }

    // func getDetailPhoto() {
    //     let uid =
    //     AuthViewModel.shared.userSession?.uid ?? ""
    //
    //     if uid != "" {
    //
    //         COLLECTION_CHANNELS.document(uid).collection("SUB").getDocuments{( querySnapshot, error) in
    //             if let error = error {
    //                 print("Failed to get documents: \(error.localizedDescription)")
    //                 return
    //             }
    //
    //             guard let documents = querySnapshot?.documents else {
    //                 print("No documents found")
    //                      return
    //             }
    //
    //             for document in documents {
    //                 let data = document.data()
    //                 if let channelUrl = data[KEY_CHANNEL_IMAGE_URL] as? String {
    //                     print("Profile URL: \(channelUrl)")
    //                 }
    //             }
    //         }
    //     }
    // }
}
