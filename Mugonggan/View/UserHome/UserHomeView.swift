//
//  UserHomeView.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/24.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct UserHomeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var userHomeModel : UserHomeViewModel
    
    @State private var selectedImage: UIImage?
    @State private var uploadBtn: Image?
    @State private var pickedImage: Image? = Image(systemName: "photo.artframe")
    @State private var openPhotoView = false
    @State private var userName = ""

    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    
    @State private var imageURLs:[URL] = []
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    
    
    
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
                            
                            CoverImageViw()
                                .frame(height: 300)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        VStack{
                            HStack {
                                Text("🔮 \(viewModel.currentUser?.name ?? "")님의 무공간 실적")
                                    .font(.system(size: 14,weight: .bold))
                                Spacer()
                            }
                            .padding(.leading, 10)
                            MyCountView()
                        }
                       
                        VStack{
                            HStack {
                                Text("🖼 \(viewModel.currentUser?.name ?? "")님의 업로드된 이미지")
                                    .font(.system(size: 14,weight: .bold))
                                    .padding(.bottom,-10)
                                Spacer()
                            }
                            .padding(.leading, 10)
                            MyUploadImageView()
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
        UserHomeView(userHomeModel: UserHomeViewModel())
            .environmentObject(AuthViewModel())
    }
}
