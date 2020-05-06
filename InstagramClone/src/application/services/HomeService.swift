//
//  HomeService.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

import Firebase
import RxSwift

class HomeService {
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func observeLoggedIn() -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            self.userRepository.fetchCurrentUser().subscribe(onNext: { (user: User?) in
                observer.onNext(user != nil)
                observer.onCompleted()
            }, onError: { (Error) in
            }, onCompleted: {
            }) {
                // onDisposed
            }
        }
    }
}
