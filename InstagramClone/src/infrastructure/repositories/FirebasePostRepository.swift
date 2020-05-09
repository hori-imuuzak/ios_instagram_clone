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
}
