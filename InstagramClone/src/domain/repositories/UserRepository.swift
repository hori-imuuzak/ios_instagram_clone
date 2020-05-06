//
//  UserRepository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

import RxSwift

protocol UserRepository {
    func fetchCurrentUser() -> Observable<User?>
    func register(user: RegisterUser) -> Observable<User?>
    func updateProfile(displayName: String) -> Observable<User?>
}
