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
    
    func loginUser(email: String, password: String) -> Observable<User?> {
        return Observable<User?>.create { (observer) -> Disposable in
            var loginUser: LoginUser? = nil
            do {
                loginUser = try LoginUser(email: email, password: password)
            } catch ModelError.illegalArgument(let paramName) {
                print("Error: " + paramName)
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            } catch {}
            
            if let loginUser = loginUser {
                self.userRepository.login(user: loginUser)
                    .subscribe(onNext: { (user: User?) in
                        observer.onNext(user)
                    }, onError: { (Error) in
                    }, onCompleted: {
                        observer.onCompleted()
                    }) {
                    }
            }
         
            return Disposables.create()
        }
    }
    
    func registerUser(email: String, password: String, displayName: String) -> Observable<User?> {
        return Observable<User?>.create { (observer) -> Disposable in
            var registerUser: RegisterUser? = nil
            do {
                registerUser = try RegisterUser(email: email, password: password, displayName: displayName)
            } catch ModelError.illegalArgument(let paramName) {
                print("Error: " + paramName)
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            } catch {}

            if let registerUser = registerUser {
                Observable.concat(
                    self.userRepository.register(user: registerUser),
                    self.userRepository.updateProfile(displayName: displayName)
                ).subscribe(onNext: { (user: User?) in
                    observer.onNext(user)
                }, onError: { (Error) in
                }, onCompleted: {
                    observer.onCompleted()
                }) {
                }
            }
            
            return Disposables.create()
        }
    }
}
