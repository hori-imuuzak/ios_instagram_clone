//
//  RegisterUser.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

class RegisterUser {
    let email: String!
    let password: String!
    let displayName: String!
    
    init(email: String, password: String, displayName: String) throws {
        if email.isEmpty {
            throw ModelError.illegalArgument(paramName: "email")
        }
        if password.isEmpty {
            throw ModelError.illegalArgument(paramName: "password")
        }
        if displayName.isEmpty {
            throw ModelError.illegalArgument(paramName: "displayName")
        }

        self.email = email
        self.password = password
        self.displayName = displayName
    }
}
