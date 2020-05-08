//
//  ModelError.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/07.
//  Copyright © 2020 umichan. All rights reserved.
//

import Foundation

enum ModelError: Error {
    case illegalArgument(String)
}

extension ModelError:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .illegalArgument(let str):
            return "\(str)が不正な値です。"
        }
    }
}
