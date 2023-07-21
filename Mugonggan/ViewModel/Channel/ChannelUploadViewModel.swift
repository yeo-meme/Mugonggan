//
//  ChannelUploadViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/07/17.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore


class ChannelUploadViewModel: ObservableObject {
    
    @Published var channel : Channel?
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    init() {
        
    }
    
    func getChanelItme() {
        guard let uid = AuthViewModel.shared.currentUser?.uid else { return }
        
        COLLECTION_CHANNELS.document(uid)
            .getDocument { snapshot, error in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    return
                }
                
                guard let documents = snapshot else { return }
                
                // self.channels = documents.compacMap({
                //     try? $0.data(as: Channel.self)
                // })
            }
    }
}
