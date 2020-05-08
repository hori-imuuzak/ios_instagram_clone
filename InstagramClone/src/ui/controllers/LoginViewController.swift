//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    private let accountService = AccountService(userRepository: FirebaseUserRepository())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setLoading(_ isLoading: Bool) {
        self.view.endEditing(true)
        
        if isLoading {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func handleClickLogin(_ sender: Any) {
        self.setLoading(true)
        
        self.accountService.loginUser(email: mailTextField.text ?? "", password: passwordTextField.text ?? "")
            .subscribe(onNext: { (user: User?) in
                if user == nil {
                    self.showAlert(message: "ログインに失敗しました。")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }, onError: { (Error) in
            }, onCompleted: {
                self.setLoading(false)
            }) {
        }.disposed(by: disposeBag)
    }
    
    @IBAction func handleClickCreateAccount(_ sender: Any) {
        self.setLoading(true)
        
        self.accountService.registerUser(
            email: mailTextField.text ?? "",
            password: passwordTextField.text ?? "",
            displayName: displayNameTextField.text ?? ""
        ).subscribe(onNext: { (user: User?) in
            if user == nil {
                self.showAlert(message: "アカウント作成に失敗しました。")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }, onError: { (Error) in
        }, onCompleted: {
            self.setLoading(false)
        }, onDisposed: {
        }).disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "アカウント作成", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { (action: UIAlertAction) in }))
        present(alert, animated: true, completion: nil)
    }

}
