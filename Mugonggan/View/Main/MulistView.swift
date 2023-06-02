//
//  MulistVIew.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/05/22.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MulistView: View {
    
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    
    @State private var gridColumn: Double = 3.0
    @State private var selectedImage: URL? = nil
    @State private var firstSelectedImage: URL? = nil
    @State private var imageSize: CGFloat = 100
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var imageURLs:[URL] = []
    @EnvironmentObject var viewModel: AuthViewModel
    
    let images: [String] = ["image1","image2","image3","image4","image5"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30){
                    
                    NavigationLink(
                        destination: MuDetailView(selectedImage: selectedImage) , label: {
                            WebImage(url:selectedImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 330, height: 330)
                                .overlay(Circle().stroke(Color.white, lineWidth: 8))
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
                    }
                }//: VSTACK
                .padding(.horizontal, 10)
                .navigationBarItems(trailing: NavigationLink(destination: UserHomeView(userHomeModel: UserHomeViewModel())) {
                    Text("\(viewModel.currentUser?.name ?? "")님 방가방가")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.black)
                })
            }//: SCROLL
            .background(MotionAnimationView())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } //: NAVAIGATION VIEW
        
        
    }
    
    
    func gridSwitch() {
        withAnimation(.easeIn) {
            gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
        }
    }
    
    /**
     storage : FOLDER_CHANNEL_IMAGES ALL
     */
    func findMatchImageUrls() {
        guard let uid = viewModel.userSession?.uid else {return}
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child("\(FOLDER_CHANNEL_IMAGES)/")
        
        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
        
        
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed to fetch image URLs: \(error.localizedDescription)")
                return
            }
            print("result:\(result?.items)")
            
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
                        print("첫번째 셀렉티드: \(selectedImage)")
                    }
                }
            }
        }
    }
}




struct MulistView_Previews: PreviewProvider {
    static var previews: some View {
        MulistView()
            .environmentObject(AuthViewModel())
    }
}
