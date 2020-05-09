//
//  PostViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class PostViewController: UIViewController, UITextFieldDelegate {
    
    var image: UIImage? = nil

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    private let postService = PostService(
        userRepository: FirebaseUserRepository(),
        postRepository: FirebasePostRepository(),
        imageRepository: FirebaseImageRepository()
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func handleClickCancel(_ sender: Any) {
    }
    
    @IBAction func handleClickPost(_ sender: Any) {
        SVProgressHUD.show()
        
        if let image = self.image {
            self.postService.createPost(image: image, caption: textField.text ?? "")
                .subscribe(onNext: { (result: Bool) in
                if result {
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    SVProgressHUD.showError(withStatus: "投稿に失敗しました。")
                }
            }, onError: { (Error) in
                SVProgressHUD.showError(withStatus: "投稿に失敗しました。")
            }, onCompleted: {
                SVProgressHUD.dismiss()
            }) {
            }.disposed(by: self.disposeBag)
        }
    }

}
