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
    
    @Published var userHome = [Channel]()

    
    init(_ user: UserInfo) {
        self.user = user
    }
    
    // init(userHome: [Channel] = [Channel]()) {
    //     self.userHome = userHome
    // }

    func getDetailPhoto() {
        let uid =
        AuthViewModel.shared.userSession?.uid ?? ""
        
        if uid != "" {
            
            COLLECTION_CHANNELS.document(uid).collection("SUB").getDocuments{( querySnapshot, error) in
                if let error = error {
                    print("Failed to get documents: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                         return
                }

                for document in documents {
                    let data = document.data()
                    if let channelUrl = data[KEY_CHANNEL_IMAGE_URL] as? String {
                        print("Profile URL: \(channelUrl)")
                    }
                }
            }
        }
    }
}
