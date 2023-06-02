//
//  DetailViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

class DetailViewModel: ObservableObject {
  
    var selectedImage: URL?
    
    //KEY_CHANNEL_IMAGE_URL
    func getDetailPhoto() {
        
        print("디테일모델들어옴 : \(selectedImage)")
        let uid =
        AuthViewModel.shared.userSession?.uid ?? ""
        
        if uid != "" {
            
            COLLECTION_CHANNELS.document(uid).collection("SUB").getDocuments{ (snapshot, error) in
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
             
                    guard let urlString = self.selectedImage?.absoluteString else {return}
                    
                    print("URL STRIng: \(urlString)")
                    
                    if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String {
                           if fieldValue == urlString {
                               // 일치하는 도큐먼트를 찾음
                               print("찾아라 데이터: \(data)")
                               print("찾아 도큐먼트: \(document)")
                               
                               if let channel = try? document.data(as: Channel.self) {
                                              // 찾은 데이터를 Channel 구조체에 저장
                                              print("Channel 데이터: \(channel)")
                                              
                                              // TODO: 필요한 로직 수행
                                          } else {
                                              print("Channel 데이터를 변환할 수 없습니다.")
                                          }
                               
                           }
                       }
                }
            }
        }
    }
}

