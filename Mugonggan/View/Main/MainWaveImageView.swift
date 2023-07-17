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
struct MainWaveImageView: View {
    
    
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var selectedImage: URL? = nil
    @State private var firstSelectedImage: URL? = nil
    @State private var imageSize: CGFloat = 100
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var imageURLs:[URL] = []
    
    @EnvironmentObject var viewModel: AuthViewModel
    // @ObservedObject var viewModel: AuthViewModel
    // @ObservedObject var waveModel: WaveSettingViewModel
    
    // @EnvironmentObject var likeModel: LikeViewModel
    // @ObservedObject var mainListModel:MainListViewModel
    
    
    // init(_ user: UserInfo) {
    //     self.mainListModel = MainListViewModel(user)
    //     self.mainListModel.getLikeDocument()
    // }
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @State private var isHeartFilled = false
    @State private var isFilled = false
    @State private var imageUrl: String?
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30){
                    Button(action: {viewModel.signOut()}) {
                        Text("로그아웃")
                    }
                    // MARK: - DETAILVIEW
                    // NavigationLink(
                    //     destination: MuDetailView(selectedImage: selectedImage) , label: {
                    //         ZStack{
                    //             WebImage(url:selectedImage)
                    //                 .resizable()
                    //                 .scaledToFill()
                    //                 .clipShape(Circle())
                    //                 .frame(width: 330, height: 330)
                    //                 .overlay(Circle().stroke(Color.red, lineWidth: 8))
                    //             VStack {
                    //                 Spacer()
                    //                 HStack {
                    //                     Spacer()
                    //                     // MARK: - LIKE BTN
                    //                     var matchingImageUrl: String? = ""
                    //                     Button(action: {
                    //                         isHeartFilled.toggle()
                    //
                    //                         if let matchImageUrl = selectedImage?.absoluteString {
                    //                             self.imageUrl = matchImageUrl
                    //                             matchingImageUrl = matchImageUrl
                    //                         }
                    //
                    //                         if isHeartFilled {
                    //                             isFilled = true
                    //                             if let imageUrl = matchingImageUrl {
                    //                                 // LikeViewModel(imageUrl,isFiiled: isFilled)
                    //                                 print("좋아요 보낸다 url \(imageUrl)")
                    //                             }
                    //                         } else {
                    //                             isFilled = false
                    //                             if let imageUrl = matchingImageUrl {
                    //                                 // LikeViewModel(imageUrl,isFiiled: isFilled)
                    //                                 print("안좋아요 보낸다 url \(imageUrl)")
                    //                             }
                    //                         }
                    //
                    //                     }, label: {
                    //                         Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                    //                             .resizable()
                    //                             .frame(width: 30,height: 30)
                    //                         .foregroundColor(.red)
                    //                         .padding(8)
                    //                         .padding(.trailing, 80)
                    //                         .padding(.bottom, 30)
                    //                     })
                    //                 }
                    //             }
                    //         }
                    //         // MARK: - 사진이 바뀔때 하트 초기화하기
                    //         .onChange(of: selectedImage) {
                    //             newValue in
                    //                 isHeartFilled = false
                    //                 isFilled = false
                    //         }
                    //     })
                   
                    
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
                        findMatchImageUrls()
                        gridSwitch()
                        // self.mainListModel.getLikeDocument()
                    }
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
        } //: NAVAIGATION VIEW
        // .onAppear{
        //     // mainListModel = MainListViewModel()
        //     mainListModel.callAllChannel()
        //     print("call")
        // }
    }
     
    
  
    // MARK: - GRID SWITCH
    func gridSwitch() {
        withAnimation(.easeIn) {
            gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
        }
    }
    
    /**
     storage : FOLDER_CHANNEL_IMAGES ALL
     */
    // MARK: -FOLDER IAMGE ALL
    func findMatchImageUrls() {
        
        
        // guard let uid = viewModel.userSession?.uid else {return}
        // let imgRef = storageRef.child("\(FOLDER_CHANNEL_IMAGES)/")
        // let storageRef = Storage.storage().reference()
        
        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
        
        
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed to fetch image URLs: \(error.localizedDescription)")
                return
            }
            print("result firestorage:\(String(describing: result?.items))")
            
            if let items = result?.items {
                for item in items {
                    item.downloadURL{ url, error in
                        if let error = error {
                            print("Failed to fetch download URL: \(error.localizedDescription)")
                            return
                        }
                        if let url = url {
                            imageURLs.append(url)
                        }
                        selectedImage = imageURLs[0]
                        print("첫번째 디테일 이미지 셀렉티드 url: \(selectedImage)")
                    }
                }
            }
        }
    }
}




// struct MulistView_Previews: PreviewProvider {
//     static var previews: some View {
//         MainWaveImageView(viewModel.currentUser ?? MOCK_USER)
//             // .environmentObject(AuthViewModel())
//     }
// }
