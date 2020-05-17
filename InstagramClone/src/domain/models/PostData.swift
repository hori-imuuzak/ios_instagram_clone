//
//  PostData.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/13.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation

class PostData {
    let id: String
    let fileName: String
    let name: String?
    let caption: String?
    let date: Date?
    let likes: [String]
    var isLiked: Bool
    
    init(id: String, fileName: String, name: String?, caption: String?, date: Date?, likes: [String], isLiked: Bool) {
        self.id = id
        self.fileName = fileName
        self.name = name
        self.caption = caption
        self.date = date
        self.likes = likes
        self.isLiked = isLiked
    }
}
