//
//  PostRepository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import RxSwift

protocol PostRepository {
    func create(post: CreatePost) -> Observable<Bool>
}
