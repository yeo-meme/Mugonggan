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
    //변경사항이 있는경우만 업데이트
    @ObservedObject var channelViewModel: ChannelViewModel
    
    let selectedImage: URL?
    @EnvironmentObject var viewModel: AuthViewModel
    var channel: Channel?
    @State private var commentText = ""
    @State private var isSubmittingComment = false
    
    
    init(selectedImage: URL?) {
           self.selectedImage = selectedImage
           self.channelViewModel = ChannelViewModel(selectedImage: selectedImage)
       }
    
    
    var body: some View {
        VStack(spacing: 1) {
            HStack{
                KFImage(channelViewModel.ownerProfileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48,height: 48)
                    .clipShape(Circle())
                    .padding(10)
                
                Text(channelViewModel.ownerProfileName ?? "")
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("팔로우")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.trailing, 10)
            }
         
            
            //like,etc
            HStack {
                HStack(spacing: 0){
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    ForEach(channelViewModel.channels) { channel in
                                                      Text(String(channel.likeCount))
                                                            .font(.system(size: 15, weight: .semibold))
                                                                                }
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        
                                        Text("좋아요")
                                            .font(.system(size: 13))
                                    }
                                    
                                    Image(systemName: "heart")
                                        .padding(.bottom,1)
                                        .frame(width: 30,height: 30)
                                    
                                }
                                    .padding()
                            )
                    }
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    ForEach(channelViewModel.channels) { channel in
                                                      Text(String(channel.bookmarkCount))
                                                            .font(.system(size: 15, weight: .semibold))
                                                                                }
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        Text("북마크")
                                            .font(.system(size: 13))
                                    }
                                 
                                    Image(systemName: "bookmark")
                                        .padding(.bottom,1)
                                    
                                }
                                    .padding()
                            )
                    }
                    VStack{
                        Rectangle()
                            .stroke(Color.black)
                            .frame(height: 100)
                            .foregroundColor(Color.white)
                            .overlay(
                                HStack {
                                    VStack{
                                        Circle()
                                            .stroke(Color.black)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                VStack{
                                                    ForEach(channelViewModel.channels) { channel in
                                                      Text(String(channel.commentCount))
                                                            .font(.system(size: 15, weight: .semibold))
                                                                                }
                                                }
                                            )
                                            .background(Circle().foregroundColor(Color.white))
                                        Divider()
                                            .background(Color.black)
                                        Text("댓글")
                                            .font(.system(size: 13))
                                    }
                              
                                    Image(systemName: "message")
                                        .padding(.bottom,1)
                                    
                                }
                                    .padding()
                            )
                    }
                }
                .background(Color("CountColor"))
                .padding(.horizontal,10)
             
            }
            
//            HStack(spacing: 70) {
//                VStack{
//                    Image(systemName: "heart")
//                        .resizable()
//                        .frame(width: 15, height: 15)
//                    ForEach(channelViewModel.channels) { channel in
//                                  Text(channel.likeCount)
//                              }
//                }
//                VStack{
//                    Image(systemName: "bookmark")
//                        .resizable()
//                        .frame(width: 15, height: 15)
//                    ForEach(channelViewModel.channels) { channel in
//                                  Text(channel.bookmarkCount)
//                              }
//                }
//                VStack{
//                    Image(systemName: "message")
//                        .resizable()
//                        .frame(width: 15, height: 15)
//                    ForEach(channelViewModel.channels) { channel in
//                                  Text(channel.commentCount)
//                              }
//                }
//
//
//            }
//            .frame(maxWidth: .infinity, maxHeight: 70)
//            .padding()
//            .cornerRadius(10)
            
            CustomDivider(leadingSpace: 0)
    
            KFImage(channelViewModel.detailImageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
        
            
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
}

struct MuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MuDetailView(selectedImage: nil)
            .environmentObject(AuthViewModel())
    }
}
