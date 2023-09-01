//
//  LikeViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/09.
//


import Foundation
import FirebaseFirestore
import FirebaseStorage



class LikeCountViewModel: ObservableObject {
    
    @Published var userInfo : UserInfo?
    @Published var channel = [Channel]()
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var imageUrl : String?
    
    var documentRef : DocumentReference?
    @Published var isFilled:Bool = false
    @Published var isLoading: Bool = false
    
    // @Published private var selectedImage: URL? = nil
    @Published var selectedImage: URL? = URL(string: "https://i.pinimg.com/564x/3e/8f/c2/3e8fc2c53b081c2e30797e63ea49540a.jpg")
    @Published var presentChannelUid:String?
    
    
    @Published var imageURLs:[URL] = []
    @Published private var initialImgUrl = ""
    
    var user: UserInfo?
    var likeUserArr: [String]?
    
    
    init() {
        // fetchPresentUser()
        // findMatchImageUrls()
        
        // GetCollectionChannel()
        
        // self.updateInitSelect()
        
        //test
        // temCallImageStorage()
    }
    
    var preUserId: String {
        return AuthViewModel.shared.currentUser?.uid ?? ""
    }
    
    func resetLikeUser() {
        self.likeUserArr = []
        self.channel = []
    }
    
    func addToLikeUser(_ name:String) {
        self.likeUserArr?.append(name)
    }
    
    
    
    // MARK: -FOLDER IAMGE ALL
    func findMatchImageUrls() {
        doAsyncWork {
            self.updateInitSelect()
        }
    }
    
    
    func fetchPresentUser() {
        COLLECTION_USERS.document(preUserId).getDocument { snapshot, error in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                return
            }
            self.userInfo = try? snapshot?.data(as: UserInfo.self)
        }
    }
    
    
    
    
    //좋아요 표시를 위한 채널정보
    func initGet() {
        
        
        resetLikeUser()
        // var presentUid = ""
        print("initialImgUrl 좋아요 표시를 위한 채널 정보 : \(initialImgUrl)")
        let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: initialImgUrl)
        
        query.getDocuments{ (snapshot, error) in
            if let errorMessage = error?.localizedDescription {
                self.showErrorAlert = true
                self.errorMessage = errorMessage
                print("error Msg: \(errorMessage)")
                return
            }
            
            guard let doc = snapshot?.documents else {return}
            for document in doc {
                let documentId = document.documentID
                // presentUid = documentId
                self.presentChannelUid = documentId
                print("initGet :도큐먼트 데이터 :\(document.data())")
                print("initGet :현재 채널 아아디  :\(self.presentChannelUid)")
            }
            
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
            
            //좋아요 한 유저
            for uidArr  in self.channel {
                self.likeUserArr?.append(contentsOf: uidArr.likewho)
            }
            
            print("initGet :좋아요 한 사람 목록 : \(self.likeUserArr)")
            self.heartInitState()
        }
    }
    
    
    // func temCallImageStorage() {
    //     let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
    //     ref.listAll { (result, error) in
    //         if let error = error {
    //             print("Failed to fetch image URLs: \(error.localizedDescription)")
    //             return
    //         }
    //         if let items = result?.items {
    //             for item in items {
    //                 item.downloadURL { url, error in
    //                     if let error = error {
    //                         print("Failed to fetch download URL: \(error.localizedDescription)")
    //                         return
    //                     }
    //
    //                     if let url = url {
    //                         self.imageURLs.append(url)
    //                         self.selectedImage = self.imageURLs[0]
    //                         print("ViewModel: 첫번째 디테일 이미지 셀렉티드 url: \(self.selectedImage)")
    //                         print("List ≈:\(self.imageURLs)")
    //                     }
    //                 }
    //             }
    //         }
    //         // 이미지 URL을 가져온 후에 completion 클로저를 호출하여 함수 종료
    //     }
    // }
    
    
    func doAsyncWork(completion: @escaping () -> Void) {
        
        var tempURLs: [URL] = [] // 임시 배열 사용
        
        let ref = Storage.storage().reference(withPath: "/\(FOLDER_CHANNEL_IMAGES)")
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed to fetch image URLs: \(error.localizedDescription)")
                return
            }
            
            
            if let items = result?.items {
                let group = DispatchGroup() //DispatchGroup생성
                
                for item in items {
                    group.enter() //작업시작
                    
                    item.downloadURL { url, error in
                        defer {
                            group.leave() //작업 완료
                        }
                        
                        if let error = error {
                            print("Failed to fetch download URL: \(error.localizedDescription)")
                            return
                        }
                        
                        if let url = url {
                            tempURLs.append(url)
                            
                            print("=======Like List Like ViewModel:\(tempURLs)")
                            self.imageURLs = tempURLs
                            print("=======Like List Like imageURLs:\(self.imageURLs)")
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.selectedImage = tempURLs[0]
                    print("=======Like List Like ViewModel: 첫번째 디테일 이미지 셀렉티드 url: \(self.selectedImage)")
                    // self.selectedImage = tempURLs.first //첫 번째 이미지 선택
                    self.imageUrl = tempURLs as? String
                    completion() //비동기 작업 완료후 completion 클로저 호출
                }
            }
            
            // 이미지 URL을 가져온 후에 completion 클로저를 호출하여 함수 종료
            // DispatchQueue.main.async {
            // completion()
            // }
        }
    }
    
    
    func updateInitSelect() {
        // var initSelectedImg = ""
        
        if let matchImageUrl = self.selectedImage {
            self.initialImgUrl = matchImageUrl.absoluteString
            print("Image URL: \(self.initialImgUrl)")
        } else {
            print("Selected image is nil")
        }
        
        
        //init Channel Collection CALL!!!
        //filled heated state setting!!!
        //좋아요 불러오기
        initGet()
    }
    
    
    //좋아요 일치 사용자가 있는지 : 하트뷰 표시
    func heartInitState(){
        guard let presentUser = AuthViewModel.shared.currentUser?.uid else {
            return
        }
        print("likeState: 전역 현사용자 : \(presentUser)")
        print("likeState :  \(likeUserArr)") //옵셔널 출력
        
        if let array = likeUserArr {
            let set = Set(array) //중복제거
            for item in set {
                if item == presentUser {
                    print("likeState 같은 사용자 : \(item)")
                    self.isFilled = true
                } else {
                    self.isFilled = false
                }
            }
        } else {
            print("옵셔널 배열이 nil입니다.")
        }
        print("likeState : isFilled State : \(isFilled)")
    }
    
    /**
     storage : FOLDER_CHANNEL_IMAGES ALL
     */
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
    
    
    func initGetChannel(_ imageUrl: String,_ likeState:String,_ user: UserInfo?) {
        
        switch likeState {
        case LIKE :
            // plusLikeCountUpdate(presentUid)
            print("LIKE")
            break
            
        case UN_LIKE:
            miusUpdate()
            print("UN_LIKE")
            break
            
            // case LIKE_STATE:
            //     likeState()
            //     break
        default:
            print("isState is empty")
            
            // }
            // let group = DispatchGroup()
            // group.enter()
            //
            // doAsyncLikeBtn(imageUrl, isState, user){
            //     //비동기 작업 완료시 그룹을 leave
            //     group.leave()
            // }
            //
            // //비동기 작업의 완료를 기다림
            // group.wait()
            //
            // // 비동기 작업이 완료 된 후 에 separationLikeState 호출
            // separationLikeState()
        }
        
        
        
        // MARK: - LIKE UPDATE
        //who : 누가 좋아요를 눌렀는지
        func doAsyncLikeBtn(_ imageUrl: String,_ isState:String,_ user : UserInfo?) {
            
            guard let userInfo = user else {
                return
            }
            
            resetLikeUser()
            self.user = userInfo
            var presentChannelUid = ""
            
            let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: imageUrl)
            
            print("누가좋아요를 눌렀는가:\(channel)")
            query.getDocuments { (snapshot, error) in
                if let errorMessage = error?.localizedDescription {
                    self.showErrorAlert = true
                    self.errorMessage = errorMessage
                    print("error Msg : \(errorMessage)")
                    return
                }
                
                guard let doc = snapshot?.documents else {return}
                
                for document in doc {
                    let documentID = document.documentID
                    presentChannelUid = documentID // 업데이트도큐먼트아이디
                    print("document data :\(document.data())")// 채널콜렉션 이미지의 도큐먼트 ID
                }
                
                let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
                self.channel.append(contentsOf: temp)
                
                //이미지정보
                for uidArr in self.channel {
                    self.likeUserArr?.append(contentsOf: uidArr.likewho)
                }
            }
        }
        
        
        
        func separationLikeState() {
            
            print("hi separationLikeState")
            //     switch likeState {
            //     case LIKE :
            //         plusLikeCountUpdate(presentUid)
            //         print("LIKE")
            //         break
            //
            //     case UN_LIKE:
            //         miusUpdate(presentUid)
            //         print("UN_LIKE")
            //         break
            //
            //     case LIKE_STATE:
            //         likeState()
            //         break
            //     default:
            //         print("isState is empty")
            //
            // }
        }
        
        func miusUpdate() {
            
            //카운팅정보
            var operateCount=0
            
            print("좋아요 했을때 채널 : \(self.channel)" )
            for item in self.channel {
                operateCount = item.likeCount
                print("좋아요 했을때 likeCount 잘 담겨있니? : \(operateCount)" )
            }
            
            operateCount -= 1
            
            
            let userUid = self.user?.uid
            // self.likeUser?.removeAll{ $0 == userUid }
           
            print("좋아요Arr 지우기전 : \(likeUserArr), user : \(userUid)" )
            if let indexToRemove = likeUserArr?.firstIndex(where: { $0 == preUserId}) {
                likeUserArr?.remove(at: indexToRemove)
                print("좋아요Arr 삭제 후  : \(likeUserArr)" )
            }
            
            
            print("좋아요Arr removeAll : \(preUserId), arr : \(likeUserArr)" )
            likeUserArr?.removeAll(where: { $0 == preUserId })
            print("좋아요Arr 삭제후 removeAll : \(likeUserArr)" )
            
            if let likeUserArr = likeUserArr {
                print("좋아요 했을때 라이크 유저 잘 담겨있니? : \(likeUserArr)" )
                let data: [String: Any] = [
                    KEY_LIKE_COUNT: operateCount,
                    KEY_LIKE_WHO: likeUserArr
                ]
                
                
                if let presentChannelUid = presentChannelUid {
                    print("presentChannelUid : \(presentChannelUid)" )
                    COLLECTION_CHANNELS.document(presentChannelUid).updateData(data) { error in
                        if let error = error {
                            print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
                        } else {
                            print("업데이트 성공!!!")
                        }
                    }
                } else {
                    print("좋아요 한 현 사용자가 없습니다 ")
                }
                
            } else {
                print("좋아요 Array nil")
            }
     
            
            
        }
        
        
        //uid 채널이미지 주인
        func plusLikeCountUpdate(_ uid:String) {
            
            var operateCount=0
            
            for item in self.channel {
                operateCount = item.likeCount
            }
            
            //사용자 : 이름 , 프로필 사진 url , uid
            guard let likeUserUid = self.user?.uid else {return}
            addToLikeUser(likeUserUid)
            
            
            operateCount += 1
            let data: [String: Any] = [
                "likeCount": operateCount,
                KEY_LIKE_WHO: self.likeUserArr
            ]
            
            COLLECTION_CHANNELS.document(uid).updateData(data) { error in
                if let error = error {
                    print("업데이트 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
