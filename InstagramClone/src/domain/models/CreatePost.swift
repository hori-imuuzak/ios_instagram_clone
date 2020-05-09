//
//  Post.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation

class CreatePost {
    let user: User!
    let imageFileName: String!
    let caption: String!
    
    init(user: User, imageFileName: String, caption: String) {
        self.user = user
        self.imageFileName = imageFileName
        self.caption = caption
    }
}
