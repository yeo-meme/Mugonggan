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
    
    @Published private var selectedImage: URL? = nil
    @Published private var imageURLs:[URL] = []
    @Published private var initialImgUrl = ""
    
    var user: UserInfo?
    var likeUser: [String]?
    
    
    init() {
        // fetchPresentUser()
        findMatchImageUrls()
    }
    
    var preUserId: String {
        return AuthViewModel.shared.currentUser?.uid ?? ""
    }
    
    func resetLikeUser() {
        self.likeUser = []
        self.channel = []
    }
    
    func addToLikeUser(_ name:String) {
        self.likeUser?.append(name)
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
    
    
    //좋아요 일치 사용자가 있는지 : 하트뷰 표시
    func likeState(){
        guard let presentUser = AuthViewModel.shared.currentUser?.uid else {
            return
        }
        print("likeState: 전역 현사용자 : \(presentUser)")
        print("likeState :  \(likeUser)")
       
        if let array = likeUser {
            let set = Set(array)
            for item in set {
                if item == presentUser {
                    print("likeState 같은 사용자 : \(item)")
                    self.isFilled = true
                }
            }
        } else {
            print("옵셔널 배열이 nil입니다.")
        }
        
        
        print("likeState : isFilled State : \(isFilled)")
        
        self.isLoading = true
        // if let isId = likeUser?.firstIndex(where: { $0 == presentUser}) {
        //     self.isFilled = false
        //     print("likeState false : \(self.isFilled)")
        //
        // } else {
        //     print("likeState true : \(self.isFilled)")
        //     self.isFilled = true
        // }
    }
    
    //좋아요 표시를 위한 채널정보
    
    func initGet(_ selectedUrl: String) {
        print("initGet : likeModel initGet selectedImg : \(selectedUrl)")
        
       
        resetLikeUser()
        var presentUid = ""
        
        let query = COLLECTION_CHANNELS.whereField(KEY_CHANNEL_IMAGE_URL, isEqualTo: selectedUrl)
        
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
                presentUid = documentId
                print("initGet :도큐먼트 데이터 :\(document.data())")
            }
            
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
            
            for uidArr  in self.channel {
                self.likeUser?.append(contentsOf: uidArr.likewho)
            }
            
            print("initGet :좋아요 한 사람 목록 : \(self.likeUser)")
            self.likeState()
        }
    }
    
    func doAsyncWork(completion: @escaping () -> Void) {
        
        // isLoading = true
        
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
        
        print("셀릭티드 이미지 스트링   : \(initialImgUrl)")
        var initSelectedImg = ""
        if let matchImageUrl = selectedImage?.absoluteString {
            initSelectedImg = matchImageUrl
        }
        
        initialImgUrl = initSelectedImg
        
        
        
        //init Channel Collection CALL!!!
        //filled heated state setting!!!
        initGet(initialImgUrl)
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
    
    
    
    // MARK: - LIKE UPDATE
    //who : 누가 좋아요를 눌렀는지
    func initGetChannel(_ imageUrl: String,_ isState:String,_ user : UserInfo?) {
        
        guard let userInfo = user else {
            return
        }
        
        resetLikeUser()
        self.user = userInfo
        var presentUid = ""
        
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
                presentUid = documentID // 업데이트도큐먼트아이디
                print("document data :\(document.data())")// 채널콜렉션 이미지의 도큐먼트 ID
            }
            
            let temp = doc.compactMap{ try? $0.data(as: Channel.self) }
            self.channel.append(contentsOf: temp)
          
            //이미지정보
            for uidArr in self.channel {
                self.likeUser?.append(contentsOf: uidArr.likewho)
            }
            
            DispatchQueue.main.async { [self] in // 메인 스레드에서 실행되도록 변경
                
                switch isState {
                case LIKE :
                    plusLikeCountUpdate(presentUid)
                    print("LIKE")
                    break
                    
                case UN_LIKE:
                    miusUpdate(presentUid)
                    print("UN_LIKE")
                    break
                    
                case LIKE_STATE:
                    likeState()
                    break
                default:
                    print("isState is empty")
                }
                
                // if (isState) {
                //     self.plusLikeCountUpdate(presentUid)
                // } else {
                //     self.miusUpdate(presentUid)
                // }
            }
        }
        
    }
    
    func miusUpdate(_ uid:String) {
        
        //카운팅정보
        var operateCount=0
        for item in self.channel {
            operateCount = item.likeCount
        }
        
        operateCount -= 1
        

        let userUid = self.user?.uid
        // self.likeUser?.removeAll{ $0 == userUid }
        
        if let indexToRemove = likeUser?.firstIndex(where: { $0 == userUid}) {
            likeUser?.remove(at: indexToRemove)
        }
        
        
        let data: [String: Any] = [
            KEY_LIKE_COUNT: operateCount,
            KEY_LIKE_WHO: self.likeUser
        ]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("도큐먼트 업데이트 에러: \(error.localizedDescription)")
            }
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
            KEY_LIKE_WHO: self.likeUser
        ]
        
        COLLECTION_CHANNELS.document(uid).updateData(data) { error in
            if let error = error {
                print("업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
}
