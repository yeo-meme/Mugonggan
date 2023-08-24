//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

// FIXME: -앱재시동하면 유저정보가 날아가서 아이디가 보이지않음
struct ChannelImageListView: View {
    
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var selectedImage: URL? = nil
    @State private var firstSelectedImage: URL? = nil
    @State private var imageSize: CGFloat = 100
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var imageURLs:[URL] = []
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var likeModel = LikeCountViewModel()
    // @ObservedObject var channelModel = ChannelListViewModel()
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @State private var isHeartFilled = false
    @State private var isFilled = false
    @State private var imageUrl: String?
    
    @State private var initialImgUrl = ""
    
    
    
    // init(_ imageUrl: String,_ isFilled: Bool) {
    //     self.likeViewModel = LikeCountViewModel(imageUrl, isFiiled: isFilled)
    //    }
   
    
    var body: some View {
   
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center, spacing: 30){
                            if !likeModel.isLoading{
                                Text("로딩중")
                                Button(action: {viewModel.signOut()}) {
                                    Text("로그아웃")
                                }
                            } else {
                                VStack{
                                    Button(action: {viewModel.signOut()}) {
                                        Text("로그아웃")
                                    }
                                    // MARK: - DETAILVIEW
                                    NavigationLink(
                                        destination: MuDetailView(selectedImage: selectedImage) , label: {
                                            ZStack{
                                                WebImage(url:selectedImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipShape(Circle())
                                                    .frame(width: 330, height: 330)
                                                    .overlay(Circle().stroke(Color.red, lineWidth: 8))
                                                VStack {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        // MARK: - LIKE BTN
                                                        var matchingImageUrl: String? = ""
                                                        Button(action: {
                                                            isHeartFilled.toggle()
                                                            
                                                            if let matchImageUrl = selectedImage?.absoluteString {
                                                                self.imageUrl = matchImageUrl
                                                                matchingImageUrl = matchImageUrl
                                                            }
                                                            
                                                            if isHeartFilled {
                                                                isFilled = true
                                                                if let imageUrl = matchingImageUrl {
                                                                    likeModel.initGetChannel(imageUrl,LIKE,viewModel.currentUser)
                                                                }
                                                            } else {
                                                                isFilled = false
                                                                if let imageUrl = matchingImageUrl {
                                                                    likeModel.initGetChannel(imageUrl,UN_LIKE,viewModel.currentUser)
                                                                    print("안좋아요 보낸다 url \(imageUrl)")
                                                                }
                                                            }
                                                            
                                                        }, label: {
                                                            Image(systemName: likeModel.isFilled ? "heart.fill" : "heart")
                                                                .resizable()
                                                                .frame(width: 30,height: 30)
                                                                .foregroundColor(.red)
                                                                .padding(8)
                                                                .padding(.trailing, 80)
                                                                .padding(.bottom, 30)
                                                        })
                                                        
                                                    }
                                                }
                                            }
                                            // MARK: - 사진이 바뀔때 하트 초기화하기
                                            .onChange(of: selectedImage) {
                                                newValue in
                                                isHeartFilled = false
                                                isFilled = false
                                            }
                                            
                                        })
                                    
                                    
                                    // MARK: - SLIDER
                                    Slider(value: $gridColumn, in : 2...4, step: 1)
                                        .padding(.horizontal)
                                        .onChange(of: gridColumn, perform: { value in
                                            gridSwitch()
                                        })
                                    
                                    // MARK: - GRID
                                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                                            ForEach(imageURLs, id: \.self) {
                                                imageURL in
                                                WebImage(url: imageURL)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                //                                    .frame(width: imageSize  , height: imageSize)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                // MARK: - IMAGE CLICK EVENT
                                                    .onTapGesture {
                                                        selectedImage = imageURL
                                                        haptics.impactOccurred()
                                                    }
                                                //                            }
                                            }
                                        } //: GRID
                                        .onAppear {
                                            likeModel.findMatchImageUrls()
                                            // findMatchImageUrls()
                                            gridSwitch()
                                        }
                                }
                            }
                  
                        
                            // }//: ELSE LOADING..................
                            
                        }//: VSTACK
                        .padding(.horizontal, 10)
                        .navigationBarItems(trailing: NavigationLink(destination: WaveSettingView(viewModel.currentUser ?? MOCK_USER)){
                            Text("\(viewModel.currentUser?.name ?? "")님 방가방가")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.black)
                        })
                }//: SCROLL
                // .background(MotionAnimationView())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // likeModel.initGet(viewModel.currentUser, selectedImage)
                // likeModel.initGetChannel(self.imageUrl? ?? "", LIKE_STATE, viewModel.currentUser)
            }
            
        } //: BODYVIEW
     

    // MARK: - GRID SWITCH
    func gridSwitch() {
        withAnimation(.easeIn) {
            gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
        }
    }
    
    // 
    // func doAsyncWork(completion: @escaping () -> Void) {
    //     let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
    //         
    //         ref.listAll { (result, error) in
    //             if let error = error {
    //                 print("Failed to fetch image URLs: \(error.localizedDescription)")
    //                 return
    //             }
    //             
    //             if let items = result?.items {
    //                 for item in items {
    //                     item.downloadURL { url, error in
    //                         if let error = error {
    //                             print("Failed to fetch download URL: \(error.localizedDescription)")
    //                             return
    //                         }
    //                         if let url = url {
    //                             imageURLs.append(url)
    //                         }
    //                         
    //                         selectedImage = imageURLs[0]
    //                         print("Channel List ViewModel: 첫번째 디테일 이미지 셀렉티드 url: \(selectedImage)")
    //                     }
    //                 }
    //             }
    //             
    //             // 이미지 URL을 가져온 후에 completion 클로저를 호출하여 함수 종료
    //             DispatchQueue.main.async {
    //                 completion()
    //             }
    //         }
    // }
    // 
    // 
    // func updateInitSelect() {
    //     var initSelectedImg = ""
    //     if let matchImageUrl = selectedImage?.absoluteString {
    //         initSelectedImg = matchImageUrl
    //     }
    //     
    //     initialImgUrl = initSelectedImg
    //   
    //     print("셀릭티드 이미지 스트링 변환후  : \(initialImgUrl)")
    //     
    //     //init Channel Collection CALL!!!
    //     //filled heated state setting!!!
    //     // likeModel.initGet(viewModel.currentUser, initialImgUrl)
    // }
    // /**
    //  storage : FOLDER_CHANNEL_IMAGES ALL
    //  */
    // // MARK: -FOLDER IAMGE ALL
    //  func findMatchImageUrls() {
    //      doAsyncWork {
    //       updateInitSelect()
    //      }
    // } //: findMatchImageUrls
    
}//: VIEW



// 
// struct MulistView_Previews: PreviewProvider {
//     static var previews: some View {
//         MainWaveImageView()
//             // .environmentObject(AuthViewModel())
//     }
// }
