//
//  UserRespository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

import Firebase
import RxSwift

class FirebaseUserRepository: UserRepository {
    func fetchCurrentUser() -> Observable<User?> {
        if let user = Auth.auth().currentUser {
            return Observable<User?>.create { (observer: AnyObserver) -> Disposable in
                observer.onNext(User(
                    userId: user.uid,
                    userName: user.displayName ?? ""
                ))
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        return Observable<User?>.create { (observer: AnyObserver) -> Disposable in
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func register(user: RegisterUser) -> Observable<User?> {
        return Observable<User?>.create { (observer: AnyObserver) -> Disposable in
            Auth.auth().createUser(withEmail: user.email, password: user.password) {
                authResult, error in
                if let error = error {
                    print("ERROR: " + error.localizedDescription)
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                
                if let user = Auth.auth().currentUser {
                    observer.onNext(User(
                        userId: user.uid,
                        userName: user.displayName ?? ""
                    ))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
