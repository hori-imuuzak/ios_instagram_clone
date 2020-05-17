//
//  FirebasePostRepository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import Firebase
import RxSwift

class FirebasePostRepository: PostRepository {
    func create(post: CreatePost) -> Observable<Bool> {
        Observable.create { (observer) -> Disposable in
            let postRef = Firestore.firestore().collection(FirebaseConst.PostPath).document()
            
            let postDic = [
                "name": post.user.userName,
                "imageFileName": post.imageFileName ?? "",
                "caption": post.caption ?? "",
                "date": FieldValue.serverTimestamp()
            ] as [String: Any]
            
            postRef.setData(postDic)
            
            observer.onNext(true)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetchPostList() -> Observable<Array<PostData>> {
        Observable.create { observer -> Disposable in
            let userId = Auth.auth().currentUser?.uid ?? ""
            let postRef = Firestore.firestore().collection(FirebaseConst.PostPath).order(by: "date", descending: true)
            postRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    observer.onCompleted()
                }
                
                let postArray: [PostData] = querySnapshot!.documents.map { document in
                    let data = document.data()
                    let likes = (data["likes"] as? [String]) ?? []
                    return PostData(
                        id: document.documentID,
                        fileName: (data["imageFileName"] as? String) ?? "",
                        name: (data["name"] as? String) ?? "",
                        caption: (data["caption"] as? String?) ?? "",
                        date: (data["date"] as? Timestamp)?.dateValue(),
                        likes: likes,
                        isLiked: likes.firstIndex(of: userId) != nil
                    )
                }
                observer.onNext(postArray)
            }
            
            return Disposables.create()
        }
    }
    
    func addFavorite(postId: String, uid: String) {
        let updateValue = FieldValue.arrayUnion([uid])
        let postRef = Firestore.firestore().collection(FirebaseConst.PostPath).document(postId)
        postRef.updateData(["likes": updateValue])
    }
    
    func removeFavorite(postId: String, uid: String) {
        let updateValue = FieldValue.arrayRemove([uid])
        let postRef = Firestore.firestore().collection(FirebaseConst.PostPath).document(postId)
        postRef.updateData(["likes": updateValue])
    }
}
