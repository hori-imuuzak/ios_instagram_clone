//
//  SettingViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    private let accountService = AccountService(userRepository: FirebaseUserRepository())
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchCurrentUserDisplayName()
    }
    
    func fetchCurrentUserDisplayName() {
        self.accountService.currentUser()
            .subscribe(onNext: { (user: User?) in
                if let user = user {
                    self.displayNameTextField.text = user.userName
                }
            }, onError: { (Error) in
            }, onCompleted: {
            }) {
        }.disposed(by: disposeBag)
    }
    
    
    @IBAction func handleClickChangeUserName(_ sender: Any) {
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        self.accountService.updateUserName(displayName: displayNameTextField.text ?? "")
            .subscribe(onNext: { (user: User?) in
                SVProgressHUD.showSuccess(withStatus: "更新しました。")
            }, onError: { (error: Error) in
                if error is ModelError {
                    SVProgressHUD.showError(withStatus: (error as! ModelError).errorDescription)
                }
            }, onCompleted: {
                SVProgressHUD.dismiss()
            }) {
        }
    }
    
    @IBAction func handleClickLogout(_ sender: Any) {
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        self.accountService.logout().subscribe(onNext: {
        }, onError: { (Error) in
        }, onCompleted: {
            if let loginViewController = self.storyboard?.instantiateViewController(identifier: "Login") {
                self.present(loginViewController, animated: true, completion: nil)
            }
            self.tabBarController?.selectedIndex = 0
        }, onDisposed: {
        }).disposed(by: disposeBag)
    }
    
}
