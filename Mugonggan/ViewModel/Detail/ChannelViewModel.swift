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
    
    var selectedDoc: String?
    var selectedImage: String?
    //    var channel: Channel?
    //KEY_CHANNEL_IMAGE_URL
    //    init (selectedImage: URL? = nil) {
    ////    init (selectedImage: URL) {
    //        self.selectedImage = selectedImage
    //        fetchChannels()
    //    }
    
    init(selectedImage: URL?) {
        self.selectedImage = selectedImage?.absoluteString
        findMatchDoc()
        print("제발 찾아줘 \(selectedImage)")
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

        }
    }
    
    var detailImageUrl: URL? {
        guard let detail = channelPartner else { return nil }
        return URL(string: detail.channelImageUrl)
    }
}
