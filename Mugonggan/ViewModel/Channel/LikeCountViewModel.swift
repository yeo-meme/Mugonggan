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
    
    
    func detailViewLoad(_ imgUrl:String) {
        print("그림 바꾸기 들어오는 URL: \(imgUrl)")
        self.resetLikeUser()
        
        let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL,isEqualTo: imgUrl)
        query.getDocuments { snapshot, error in
            guard let doc = snapshot?.documents else {
                return
            }
            for document in doc {
                let documentId = document.documentID
                self.presentChannelUid = documentId
                print("DispatchQueue 순서 : 2")
            }
            
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
            
            //좋아요 한 유저
            for uidArr  in self.channel {
                self.likeUserArr?.append(contentsOf: uidArr.likewho)
            }
            
            
            //view 상태값 변경해주어야
            if let url = URL(string: imgUrl) {
                self.selectedImage = url
            }
            
            
            //view changing
            self.heartInitViewState()
        }
    }
    
    //좋아요 표시를 위한 채널정보
    func renewChannelCollection(_ imgUrl: String, completion: @escaping () -> ()) {
        print("DispatchQueue 순서 : RenewChannelCollection 1")
        
        
        self.resetLikeUser()
        let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: imgUrl)
        
        let group: DispatchGroup = DispatchGroup()
        group.enter()
        
        query.getDocuments { snapshot, error in
            guard let doc = snapshot?.documents else {
                group.leave()
                return
            }
            for document in doc {
                let documentId = document.documentID
                self.presentChannelUid = documentId
                print("DispatchQueue 순서 : 2")
            }
            
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
            
            //좋아요 한 유저
            for uidArr  in self.channel {
                self.likeUserArr?.append(contentsOf: uidArr.likewho)
            }
            
            
            //view changing
            self.heartInitViewState()
            
            completion()
            group.leave()
        }
    }
  
    
    
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
                            self.imageURLs = tempURLs
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.selectedImage = tempURLs[0]
                    self.imageUrl = tempURLs as? String
                    completion() //비동기 작업 완료후 completion 클로저 호출
                }
            }
        }
    }
    
    
    func updateInitSelect() {
        // var initSelectedImg = ""
        
        if let matchImageUrl = self.selectedImage {
            self.initialImgUrl = matchImageUrl.absoluteString
            print("선택한 사진값 : \(matchImageUrl)")
        } else {
            print("Selected image is nil")
        }
        
        
        //init Channel Collection CALL!!!
        //filled heated state setting!!!
        //좋아요 불러오기
        renewChannelCollection(self.initialImgUrl) { }
    }
    
    
    //좋아요 일치 사용자가 있는지 : 하트뷰 표시 : 버튼활성호
    func heartInitViewState(){
        print("heartInitState 순서 2-2 ")
        guard let presentUser = AuthViewModel.shared.currentUser?.uid else {
            return
        }
        
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
        print("자기 사진 이니? likeState 하트 상태: isFilled State : \(isFilled)")
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
        
        
        
        //imageUrl 현재 이미지 URL
        renewChannelCollection(imageUrl){
            switch likeState {
            case LIKE :
                self.plusLikeCountUpdate()
                print("LIKE")
                self.isFilled = true
                break
                
            case UN_LIKE:
                self.miusUpdate()
                print("UN_LIKE")
                self.isFilled = false
                break
                
            default:
                print("isState is empty")
                
            }
        }
        
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
        print("miusUpdate() 2")
        //카운팅정보
        var operateCount=0
        
        print("좋아요 했을때 채널 : \(self.channel)" )
        for item in self.channel {
            operateCount = item.likeCount
            print("좋아요 했을때 likeCount 잘 담겨있니? : \(operateCount)" )
        }
        
        operateCount -= 1
        
        
        // let userUid = self.user?.uid
        // self.likeUser?.removeAll{ $0 == userUid }
        
        if let indexToRemove = likeUserArr?.firstIndex(where: { $0 == preUserId}) {
            print("좋아요Arr 리무브인덱스!!!!!! : \(indexToRemove)" )
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
    func plusLikeCountUpdate() {
        print("plus Update() 2")
        var operateCount=0
        
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        //사용자 : 이름 , 프로필 사진 url , uid
        // guard let likeUserUid = preUserId else {return}
        self.likeUserArr?.append(preUserId)
        
        
        operateCount += 1
        if let likeUserArr = self.likeUserArr {
            let data: [String: Any] = [
                KEY_LIKE_COUNT: operateCount,
                KEY_LIKE_WHO: likeUserArr
            ]
            
            if let presentChannelUid = presentChannelUid {
                COLLECTION_CHANNELS.document(presentChannelUid).updateData(data) { error in
                    if let error = error {
                        print("업데이트 실패: \(error.localizedDescription)")
                    } else {
                        print("플러스 업데이트 성공")
                    }
                }
            }
        } else {
            print("likeUserArr nil")
        }
        
    }
}
