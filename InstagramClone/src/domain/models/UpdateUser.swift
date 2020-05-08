//
//  RegisterUser.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

class UpdateUser {
    let displayName: String!
    
    init(displayName: String) throws {
        if displayName.isEmpty {
            throw ModelError.illegalArgument("displayName")
        }

        self.displayName = displayName
    }
}
