//
//  CouutViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/12.
//

import Foundation
import FirebaseFirestore
import Firebase

class CountViewModel: ObservableObject {
    
    @Published var channel: Channel?
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    //firebase 인증된 사용자 타입 User
    // @Published var userSession: User?
    
    // MARK: - 최상위 user모델을받아서 사용할꺼야..
    let authViewModel: AuthViewModel
    
    @Published var totalLikes = 0
    @Published var totalBookmark = 0
    @Published var totalComments = 0
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        // self.userSession = userSession
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = authViewModel.userSession?.uid else { return }
        print("누구냐 너 \(uid)")
        let query = COLLECTION_CHANNELS_ZIP.whereField(KEY_UID, isEqualTo: uid)
        
        query.getDocuments{ (snapshot, error) in
            if let error = error {
                print("도큐먼트 검색 에러: \(error.localizedDescription)")
            }
            
            guard let documents = snapshot?.documents else {
                print("도큐먼트 없음")
                return
            }
            
         
            
            for document in documents {
                if let channel = try? document.data(as: Channel.self) {
              
                    self.totalLikes += channel.likeCount
                    self.totalBookmark += channel.bookmarkCount
                    self.totalComments += channel.commentCount
                    
                    print("라이크: \(self.totalLikes) , 북마크 \(self.totalBookmark), 커맨트 \(self.totalComments)")
                    
                    self.channel = channel
                    
                 
                } else {
                    print("해당 필드가 존재하지 않아")
                }
            }
        }
    }
}
