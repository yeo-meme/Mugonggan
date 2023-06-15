//
//  MainListViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/15.
//

import Foundation
import FirebaseStorage

class MainListViewModel: ObservableObject {
 
    // ???: let 변수선언과 Published 선언의 차이점을 잘모르겠네
    @Published var channel = [Channel]()
    @Published var errorMessage = ""
    @Published var showErrorAlert = false

    
    func callAllChannel() {
        COLLECTION_CHANNELS_ZIP.getDocuments{ snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
         
            guard let documents = snapshot?.documents else { return }
            
            self.channel = documents.compactMap({ try? $0.data(as: Channel.self) })
            
            print("모두 다 불러와 \(self.channel)")
        }
        
    }
}
