//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    private let registerService = RegisterService(userRepository: FirebaseUserRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
    }
    
    @IBAction func createAccount(_ sender: Any) {
        // TODO: ボタン押せなくしてローディングを表示する
        
        self.registerService.registerUser(
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
        }, onDisposed: {
        })
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "アカウント作成", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { (action: UIAlertAction) in }))
        present(alert, animated: true, completion: nil)
    }

}
