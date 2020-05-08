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
    
    func login(user: LoginUser) -> Observable<User?> {
        return Observable<User?>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: user.email, password: user.password) { (result: AuthDataResult?, error: Error?) in
                if let error = error {
                    print("ERROR: " + error.localizedDescription)
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                
                if let firebaseUser = result?.user {
                    observer.onNext(User(
                        userId: firebaseUser.uid,
                        userName: firebaseUser.displayName ?? ""
                    ))
                }
                
                observer.onCompleted()
            }
            
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
                
                if let user = authResult?.user {
                    observer.onNext(User(
                        userId: user.uid,
                        userName: user.displayName ?? ""
                    ))
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func updateProfile(displayName: String) -> Observable<User?> {
        return Observable<User?>.create { (observer: AnyObserver) -> Disposable in
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("ERROR: " + error.localizedDescription)
                    }
                    
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
    
    func logout() -> Observable<Void> {
        return Observable<Void>.create { (observer) -> Disposable in
            try? Auth.auth().signOut()
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
