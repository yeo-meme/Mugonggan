//
//  DetailViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

// MARK: - MAIN VIEW MODEL
// Detail View 호출시 해당 도큐먼트를 selectedUrl로 찾는다

class ChannelViewModel: ObservableObject {
    
    @Published var channels = [Channel]()
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var channelPartner: Channel?
    @Published var owner: Owner?
    
    var selectedDoc: String?
    var selectedImage: String?
    
    init(selectedImage: URL?) {
        self.selectedImage = selectedImage?.absoluteString
        findMatchDoc()
    }
    
    // MARK: - SELECTEDURL로 일치 채널콜렉션 찾기
    func findMatchDoc() {
        COLLECTION_CHANNELS_ZIP.getDocuments{ [weak self ](snapshot, error) in
            
            guard let documents = snapshot?.documents else {
                print("검색 결과가 없습니다.")
                return
            }
         
            if let selectedImage = self?.selectedImage {
                let selectedDoc = documents.first { document in
                    let data = document.data()
                    if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String,
                       fieldValue == selectedImage {
                        return true
                    }
                    return false
                }
                self?.selectedDoc = selectedDoc?.documentID
                print("이미지 주소같은 채널 ID get : \(selectedDoc)")
            }
            // ???: 반복 호출이 많아서 구문을 바꿨더니 호출 수가 급 줄었다 이유가 뭔지 찾아야한다
            // TODO: for문대신 documents.first 사용하기 : DONE
            // for document in documents {
            //     let data = document.data()
            //     print("채널 콜렉션 모두 get´ \(data)")
            //
            //
            //     if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String {
            //         if let url = URL(string: fieldValue), url.absoluteString == self.selectedImage {
            //             self.selectedDoc = document.documentID
            //         }
            //     }
            // }
            self?.fetchDetail()
        }
    }
    
    // MARK: - 채널정보와 일치하는 USER콜렉션 get
    func ownerFetch(uid: String) {
        if uid != "" {
            let query = COLLECTION_USERS.document(uid)
            
            query.getDocument{ snapshot, error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    return
                }
                
                self.owner = try? snapshot?.data(as: Owner.self)
                print("채널정보와 일치하는 USER콜렉션 get 패치 완료 \(self.owner)")
            }
        }
        
    }
    
    
    //error Channel 데이터를 변환할 수 없습니다.
   // MARK: - CHANNEL INFO GET 채널모델 저장 and User콜렉션 호출을 위한 함수 호출
    func fetchDetail() {
        guard let doc = selectedDoc else {return}
        let query = COLLECTION_CHANNELS_ZIP.document(doc)
        
        query.getDocument{(snapshot, error) in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            //데이터 변환
            if let channel = try? snapshot?.data(as: Channel.self) {
                print("Channel 데이터: \(channel)")
                self.channels.append(channel)
            } else {
                print("Channel 데이터를 변환할 수 없습니다.")
            }
            
            self.channelPartner = try? snapshot?.data(as: Channel.self)
        
            print("채널 정보 가져왔스 : \(self.channelPartner)")
            self.ownerFetch(uid: self.channelPartner?.uid ?? "")
        }
    }
    
    var detailImageUrl: URL? {
        guard let detail = channelPartner else { return nil }
        return URL(string: detail.channelImageUrl)
    }
    var ownerProfileImage: URL? {
        guard let ownerProfile = owner else { return nil }
        return URL(string: ownerProfile.profileImageUrl)
    }
    
    var ownerProfileName: String? {
        guard let ownerName = owner else { return nil }
        return ownerName.name
    }
}
