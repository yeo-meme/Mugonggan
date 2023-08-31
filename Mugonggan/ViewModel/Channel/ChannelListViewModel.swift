//
//  MainListViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/15.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ChannelListViewModel: ObservableObject {
    
    // ???: let 변수선언과 Published 선언의 차이점을 잘모르겠네
    // @Published var channel = [ChannelZip]()
    // @Published var likewho = [LikeWho]()
    
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    @Published var user : UserInfo?
    @Published var channel : [Channel]?
   
    
    @Published private var selectedImage: URL? = nil
    @Published private var imageURLs:[URL] = []
    @Published private var initialImgUrl = ""
    // TODO:
    //1. 로드시 channel의 모든데이터 불러오기
    //
    init() {
        guard let currentId = AuthViewModel.shared.currentUser else { return }
        self.user = currentId
        GetCollectionChannel()
    }
    
    // var channelImageUid : String {
    //     guard let channelPartner = channel else { return "" }
    //     return channelPartner.uid
    // }
    
    // func getAllWave() {
    //     Task{
    //         let auth = try AuthViewModel.shared.currentUser
    //         let userId = auth?.uid
    //         let userChannel = try? await UserManager.shared.getChannelDoc(userId: userId!)
    //
    //         var localArray: [Channel] = []
    //         for channelImg in channel {
    //             if let product = try? await UserManager.getChannelDoc(userId: String(userId!)) {
    //                 localArray.append((channel))
    //             }
    //         }
    //         self.channel = localArray
    //     }
    //     print("get wave : \(channel)")
    // }
    
    
    //Document get test
    func GetDocumentTest() {
        
        let userId = user?.uid
        
        print("문서만불러오기 id: \(userId)")
        
        COLLECTION_CHANNELS_ZIP.document("c2b1W8znOdgP2J00irTD").getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    //SUB 데이터출력 테스트
    // func getLikeDocument() {
    //
    //     guard let uid = user?.uid else {
    //         return
    //     }
    //     print("MainListViewModel/ get LikeViewModel : \(uid)")
    //
    //     let query = COLLECTION_CHANNELS
    //         .document(uid).collection("SUB")
    //
    //
    //     query.getDocuments{ snapshot, error in
    //         if let errorMessage = error?.localizedDescription {
    //             self.showErrorAlert = true
    //             self.errorMessage = errorMessage
    //             return
    //         }
    //
    //         guard let documents = snapshot?.documents else { return }
    //
    //         print("변환전 like data : \(documents)")
    //
    //         for document in documents {
    //             print("변환전 내용: \(document.data())")
    //         }
    //
    //         do {
    //             //변환에러는 나지 않는데
    //             // let likeWhoSnap = documents.compactMap({ try? $0.data(as: LikeWho.self)})
    //             // self.likewho = likeWhoSnap
    //             // print("MainListViewModel/ likewho \(self.likewho)")
    //         } catch {
    //             print("error like who: \(error)")
    //         }
    //
    //     }
    // }
    
    
    
    // Cannel All 도큐먼트 call
    func GetCollectionChannel() {
        
        COLLECTION_CHANNELS.getDocuments { snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let channelTemp = documents
                .compactMap({ try? $0.data(as: Channel.self) })
            
            self.channel = channelTemp
            // self.channel = channelTest
            print("Channel LIst VIewModel: 변환해 \(self.channel)")
        }
    }
    
    
    
    
    func doAsyncWork(completion: @escaping () -> Void) {
        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
        
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed to fetch image URLs: \(error.localizedDescription)")
                return
            }
            
            if let items = result?.items {
                for item in items {
                    item.downloadURL { url, error in
                        if let error = error {
                            print("Failed to fetch download URL: \(error.localizedDescription)")
                            return
                        }
                        if let url = url {
                            self.imageURLs.append(url)
                        }
                        
                        self.selectedImage = self.imageURLs[0]
                        print("Channel List ViewModel: 첫번째 디테일 이미지 셀렉티드 url: \(self.selectedImage)")
                    }
                }
            }
            
            // 이미지 URL을 가져온 후에 completion 클로저를 호출하여 함수 종료
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func updateInitSelect() {
        var initSelectedImg = ""
        if let matchImageUrl = selectedImage?.absoluteString {
            initSelectedImg = matchImageUrl
        }
        
        initialImgUrl = initSelectedImg
        
        print("셀릭티드 이미지 스트링 변환후  : \(initialImgUrl)")
        
        //init Channel Collection CALL!!!
        //filled heated state setting!!!
        // likeModel.initGet(viewModel.currentUser, initialImgUrl)
    }
    /**
     storage : FOLDER_CHANNEL_IMAGES ALL
     */
    // MARK: -FOLDER IAMGE ALL
    func findMatchImageUrls() {
        doAsyncWork {
            self.updateInitSelect()
        }
    } //: findMatchImageUrls
    
    
    //
    // func miusUpdate() {
    //     // var newLike = 0
    //     // if let unwrappedChannel = channel {
    //     //    let likeCount = unwrappedChannel.likeCount
    //     //         newLike = likeCount-1
    //     //         print("existLike: \(likeCount)")
    //     //         print("newLike: \(newLike)")
    //     // } else{
    //     //     print("Failed to get channel")
    //     // }
    //
    //     // let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
    //     // documentRef.updateData(data) { error in
    //     //     if let error = error {
    //     //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
    //     //     } else {
    //     //         print("도큐먼트 업데이트 성공")
    //     //     }
    //     // }
    // }
    //
    // // MARK: - 좋아요 증가
    // func likePlusUpdate() {
    //     var newLike = 0
    //     let userId = user?.uid
    //
    //
    //
    //     // guard let unwrappedChannel = channel else {return}
    //
    //     // let likeCount = channel.likeCount
    //
    //         // newLike = likeCount+1
    //         // print("existLike: \(likeCount)")
    //         // print("newLike: \(newLike)")
    //         //
    //
    //     //
    //     // let data: [String: Any] = [KEY_LIKE_COUNT: newLike]
    //     // documentRef.setData(data) { error in
    //     //     if let error = error {
    //     //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
    //     //     } else {
    //     //         print("도큐먼트 업데이트 성공")
    //     //     }
    //     // }
    //     //
    //     // let likeData: [String: Any] = ["likewho" : likeName ]
    //     // likeCollection.updateData(likeData) { error in
    //     //     if let error = error {
    //     //         print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
    //     //     } else {
    //     //         print("도큐먼트 업데이트 성공")
    //     //     }
    //     // }
    // }
    

}
