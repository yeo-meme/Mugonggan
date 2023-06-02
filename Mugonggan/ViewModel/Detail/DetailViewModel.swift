//
//  DetailViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/02.
//

import SwiftUI

struct DetailViewModel: View {
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    //AuthViewModel.shared.currentUser?.name ?? ""
    func getUserPhoto() {
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

struct DetailViewModel_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewModel()
    }
}
