//
//  FirebaseImageRepository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class FirebaseImageRepository: ImageRepository {
    func uploadImage(fileName: String, imageData: Data) -> Observable<String?> {
        return Observable.create { observer -> Disposable in
            let imageRef = Storage.storage().reference().child(FirebaseConst.ImagePath).child("\(fileName).jpg")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metaData) { metaData, error in
                if error != nil {
                    observer.onError(FirebaseError.uploadImageError(fileName))
                } else {
                    observer.onNext(fileName)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
