//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct WaveSettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // !!!: .environmentObject(AuthViewModel()) 상위계층에서 주입되서 사용할수 있음
    @EnvironmentObject var viewModel: AuthViewModel
    
    // !!!: ObservableObject 프로토콜을 준수하는 객체에 사용 : SwiftUI에서 상태 변경을 감지하고 해당 변경을 알리는 데 사용되는 프로토콜로 뷰를 자동 업데이트한다
    @State private var selectedImage: UIImage?
    @State private var uploadBtn: Image?
    @State private var pickedImage: Image? = Image(systemName: "photo.artframe")
    @State private var openPhotoView = false
    @State private var userName = ""

    @State private var userInfo:UserInfo?
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    
    @State private var imageURLs:[URL] = []
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    // init(_ user: UserInfo) {
    //     self.viewModel = EditProfileViewModel(user)
    // }
    
    
    init(_ user: UserInfo) {
        self.userInfo = user
        // self.waveSettingViewModel = WaveSettingViewModel(user)
    }
    
    var body: some View {
       
        let userHomeNameCell = UserHomeNameCell(viewModel)
        
        NavigationView {
            ScrollView{
                ZStack {
                    VStack(spacing: 10){
                        VStack{
                            HStack {
                                Text("❤️‍🔥를 많은 받은 \(viewModel.currentUser?.name ?? "")님의 무공간")
                                    .font(.system(size: 14,weight: .bold))
                                Spacer()
                            }
                            .padding(.leading, 10)
                            
                            CoverImageView()
                                .frame(height: 300)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        // MARK: - COUNTVIEW
                        VStack{
                            HStack {
                                Text("🔮 \(viewModel.currentUser?.name ?? "")님의 무공간 실적")
                                    .font(.system(size: 14,weight: .bold))
                                Spacer()
                            }
                            .padding(.leading, 10)
                            // MyCountView(viewModel.currentUser ?? MOCK_USER)
                                // .environmentObject(viewModel)
                            // MyCountView(countViewModel: CountViewModel(userSession: viewModel.userSession))
                            //     .environmentObject(viewModel)
                        }
                       
                        VStack{
                            HStack {
                                Text("🖼 \(viewModel.currentUser?.name ?? "")님의 업로드된 이미지")
                                    .font(.system(size: 14,weight: .bold))
                                    .padding(.bottom,-10)
                                Spacer()
                            }
                            .padding(.leading, 10)
                            //view로 보여지는 이미지
                            MyUploadImageView(viewModel: ChannelUploadViewModel())
                        }
                    }
                    .padding(.top, 20)
                }//: ZSTACK
                .navigationBarTitle(userName, displayMode: .inline)
                .navigationBarItems(leading:
                                        NavigationLink(destination: SettingView(viewModel.currentUser ?? MOCK_USER)) {
                    UserHomeProfileCell()
                },trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .foregroundColor(Color.black)
                })
                .onAppear {
                    userName = viewModel.currentUser?.name ?? ""
                }
                
                
                // MARK: - PLUS BTN
                .overlay(
                    ZStack{
                        Button(action: {
                            self.openPhotoView = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .background(Circle().fill(Color("CountColor")))
                                .frame(width: 48,height: 48,alignment: .center)
                        })
                        .sheet(isPresented: $openPhotoView) {
                            UploadChannelPhotoView()
                        }
                    }//: ZSTACK
                        .padding(.bottom, 15)
                        .padding(.trailing,15) , alignment: .bottomTrailing
                )
            }//:Scroll
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - LOAD IMAGE
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        pickedImage = Image(uiImage:  selectedImage)
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WaveSettingView(AuthViewModel.shared.currentUser ?? MOCK_USER)
    }
}
