//
//  ImageRepository.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/09.
//  Copyright © 2020 umichan. All rights reserved.
//

import RxSwift

protocol ImageRepository {
    func uploadImage(fileName: String, imageData: Data) -> Observable<String?>
    func fetchImage(fileName: String) -> Observable<AnyObject>
}
