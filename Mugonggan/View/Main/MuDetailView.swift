//
//  MuDetailView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/23.
//

import SwiftUI
import Kingfisher
import FirebaseStorage
import Firebase

struct MuDetailView: View {
    let selectedImage: URL?
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var commentText = ""
    @State private var isSubmittingComment = false
    
    var body: some View {
        VStack(spacing: 1) {
            HStack{
                //                UserHomeProfileCell()
                
                Button(action: {
                    getDetailPhoto()
                }) {
                    Text("팔로우")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            if let imageURL = selectedImage {
                Text("Selected Image: \(imageURL)")
            } else {
                Text("No Image Selected")
            }
            
            
            
            HStack(spacing: 70) {
                
                VStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("좋아요")
                }
                VStack{
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("북마크")
                }
                VStack{
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("댓글")
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: 70)
            .padding()
            .cornerRadius(10)
            
            
            CustomDivider(leadingSpace: 0)
            
            // MARK: - dummy
            Image("image1")
                .resizable()
                .scaledToFit()
                .padding()
            
            
            //            KFImage(selectedImage)
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .padding()
            
            VStack {
                HStack{
                    TextField("코멘트를 남겨보세요", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 44)
                        .padding()
                    
                    Button(action: submitComment) {
                        Text("OK")
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color("FollowColor"))
                            .cornerRadius(10)
                    }
                    
                    .disabled(commentText.isEmpty || isSubmittingComment)
                    .opacity(commentText.isEmpty || isSubmittingComment ? 0.5 : 1)
                }
                
                if isSubmittingComment {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
            Spacer()
        }
        
        
    }
    func submitComment() {
        // 댓글 작성 로직 구현
        // 이곳에서 작성된 댓글을 서버에 전송하거나 필요한 작업을 수행할 수 있습니다.
        
        // 댓글 작성 후 필요한 초기화 작업
        commentText = ""
        isSubmittingComment = true
        
        // 댓글 작성이 완료되면 isSubmittingComment를 false로 설정하여 버튼을 다시 활성화합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmittingComment = false
        }
    }
    //KEY_CHANNEL_IMAGE_URL
    
    func getDetailPhoto() {
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
             
                    guard let urlString = selectedImage?.absoluteString else {return}
                    
                    print("URL STRIng: \(urlString)")
                    
                    if let fieldValue = data[KEY_CHANNEL_IMAGE_URL] as? String {
                           if fieldValue == urlString {
                               // 일치하는 도큐먼트를 찾음
                               print("찾아라 데이터: \(data)")
                               print("찾아 도큐먼트: \(document)")
                           }
                       }
                }
            }
            
            
//            COLLECTION_CHANNELS.document(uid).collection("SUB")
//                .whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: selectedImage)
//                .getDocuments{ (snapshot, error) in
//                    if let error = error {
//                        print("도큐먼트 검색 에러: \(error.localizedDescription)")
//                    }
//
//                    guard let documents = snapshot?.documents else {
//                        print("검색 결과가 없습니다.")
//                        return
//                    }
//
//                    for document in documents {
//                        let data = document.data()
//                        print("디테일과 일치하는 도큐먼트 \(data)")
//                    }
//                }
        }
    }
}

struct MuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MuDetailView(selectedImage: nil)
            .environmentObject(AuthViewModel())
    }
}
