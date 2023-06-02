//
//  DetailViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

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
    
    func findMatchDoc() {
        COLLECTION_CHANNELS_ZIP.getDocuments{(snapshot, error) in
            if let error = error {
                print("도큐먼트 검색 에러: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {
                print("검색 결과가 없습니다.")
                return
            }
            for document in documents {
                let data = document.data()
                print("디테일과 일치하는 data´ \(data)")
                
                
                if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String {
                    if let url = URL(string: fieldValue), url.absoluteString == self.selectedImage {
                        self.selectedDoc = document.documentID
                    }
                }
            }
            self.fetchDetail()
        }
    }
    
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
                print("패치 완료 \(self.owner)")
            }
        }
        
    }
    
    func fetchDetail() {
        guard let doc = selectedDoc else {return}
        let query = COLLECTION_CHANNELS_ZIP.document(doc)
        
        query.getDocument{(snapshot, error) in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            if let channel = try? snapshot?.data(as: Channel.self) {
                print("Channel 데이터: \(channel)")
                self.channels.append(channel)
            } else {
                print("Channel 데이터를 변환할 수 없습니다.")
            }
            self.channelPartner = try? snapshot?.data(as: Channel.self)
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
