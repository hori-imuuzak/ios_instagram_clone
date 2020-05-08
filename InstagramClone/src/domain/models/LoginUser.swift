//
//  RegisterUser.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

class LoginUser {
    let email: String!
    let password: String!
    
    init(email: String, password: String) throws {
        if email.isEmpty {
            throw ModelError.illegalArgument("email")
        }
        if password.isEmpty {
            throw ModelError.illegalArgument("password")
        }

        self.email = email
        self.password = password
    }
}
