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
                        // 일치하는 도큐먼트를 찾음
                        print("찾아라 데이터: \(data)")
                        print("찾아 도큐먼트: \(document)")
                        
                        //                        document.documentID
                        
                        print("넘엉와제발 \(document.documentID)")
                        //                        fetchedChannels.append(data)
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
                                    // 찾은 데이터를 Channel 구조체에 저장
                                    print("Channel 데이터: \(channel)")
                self.channels.append(channel)
                                } else {
                                    print("Channel 데이터를 변환할 수 없습니다.")
                                }
//
//            guard let channel = try? snapshot?.data(as: Channel.self) else { return }
//            self.channels = channel
        }
    }
}




//        COLLECTION_CHANNELS_ZIP.getDocuments{ (snapshot, error) in
//            if let error = error {
//                print("도큐먼트 검색 에러: \(error.localizedDescription)")
//            }
//            guard let documents = snapshot?.documents else {
//                print("검색 결과가 없습니다.")
//                return
//            }
//
//            var fetchedChannels = [Channel]()
//
//
//            for document in documents {
//                let data = document.data()
//                print("디테일과 일치하는 data´ \(data)")
//
//                guard let urlString = self.selectedImage?.absoluteString else {continue}
//
//                print("URL STRIng: \(urlString)")
//
//                if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String {
//                    if fieldValue == urlString {
//                        // 일치하는 도큐먼트를 찾음
//                        print("찾아라 데이터: \(data)")
//                        print("찾아 도큐먼트: \(document)")
//                        if let channel = try? document.data(as: Channel.self) {
//                            // 찾은 데이터를 Channel 구조체에 저장
//                            print("Channel 데이터: \(channel)")
//                            fetchedChannels.append(channel)
//
//                            // TODO: 필요한 로직 수행
//                        } else {
//                            print("Channel 데이터를 변환할 수 없습니다.")
//                        }
//                    } else {
//                        print("일치가 없음 \(fieldValue) 넘어온 \(urlString)")
//                    }
//                }
//                self.channels = fetchedChannels
//            }
//        }

//            guard let documents = snapshot?.documents else { return }
