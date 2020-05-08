//
//  HomeTabBarController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import RxSwift

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let accountService = AccountService(userRepository: FirebaseUserRepository())

    override func viewDidAppear(_ animated: Bool) {
        accountService.checkLoggedIn().subscribe(onNext: { (isLoggedIn: Bool) in
            if !isLoggedIn {
                if let loginViewController = self.storyboard?.instantiateViewController(identifier: "Login") {
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }, onError: { (Error) in
        }, onCompleted: {
        }) {
            print("disposed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            // モーダル表示
            if let imageSelectViewController = storyboard?.instantiateViewController(identifier: "ImageSelect") {
                present(imageSelectViewController, animated: true)
                return false
            }
        }
        
        return true
    }

}
