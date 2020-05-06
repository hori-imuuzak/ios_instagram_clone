//
//  RegisterService.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

import RxSwift

class RegisterService {
    private var userRepository: UserRepository!
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func registerUser(email: String, password: String, displayName: String) -> Observable<User?> {
        return Observable<User?>.create { (observer) -> Disposable in
            if email.isEmpty || password.isEmpty || displayName.isEmpty {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let registerUser = try! RegisterUser(email: email, password: password, displayName: displayName)
            
            Observable.zip(
                self.userRepository.register(user: registerUser),
                self.userRepository.updateProfile(displayName: displayName)
            ).subscribe(onNext: { (registerUser: User?, updateUser: User?) in
                observer.onNext(updateUser)
            }, onError: { (Error) in
            }, onCompleted: {
                observer.onCompleted()
            }) {
            }
            
            return Disposables.create()
        }
    }
}
