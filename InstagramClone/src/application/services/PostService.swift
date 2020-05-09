//
//  PostService.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import RxSwift

class PostService {
    private var userRepository: UserRepository!
    private var postRepository: PostRepository!
    private var imageRepository: ImageRepository!
    
    init(
        userRepository: UserRepository,
        postRepository: PostRepository,
        imageRepository: ImageRepository
    ) {
        self.userRepository = userRepository
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }
    
    func createPost(image: UIImage, caption: String) -> Observable<Bool> {
        let fileName = self.generateRandomStr()
        
        if let imageData = image.jpegData(compressionQuality: 0.75) {
            return self.userRepository
                .fetchCurrentUser()
                .flatMap { (user: User?) -> Observable<User?> in
                    return self.imageRepository.uploadImage(fileName: fileName, imageData: imageData).flatMap { (_: String?) -> Observable<User?> in
                        return Observable.of(user)
                    }
                }.flatMap { (user: User?) -> Observable<Bool> in
                    if user != nil {
                        let post = CreatePost(user: user!, imageFileName: fileName, caption: caption)
                        return self.postRepository.create(post: post)
                    }
                    
                    return Observable.of(false)
            }
        }
        
        return Observable.of(false)
    }
    
    private func generateRandomStr(length: Int = 16) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var str = ""
        
        for _ in 0 ..< length {
            let index = Int.random(in: 0 ..< base.count)
            let from = base.index(base.startIndex, offsetBy: index)
            let to = base.index(from, offsetBy: 1)
            str += "\(base[from...to])"
        }
        
        return str
    }
}
