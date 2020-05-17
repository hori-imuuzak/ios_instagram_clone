//
//  ViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postTableView: UITableView!
    var postArray: [PostData] = []
    
    private let accountService = AccountService(userRepository: FirebaseUserRepository())
    private let postService = PostService(
        userRepository: FirebaseUserRepository(),
        postRepository: FirebasePostRepository(),
        imageRepository: FirebaseImageRepository()
    )
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.accountService.checkLoggedIn()
            .flatMap({ (isLoggedIn: Bool) -> Observable<Array<PostData>> in
                if (isLoggedIn) {
                    return self.postService.fetchPostList()
                } else {
                    return Observable.of([])
                }
            }).subscribe(onNext: { (postArray: Array<PostData>) in
                self.postArray = postArray
                self.postTableView.reloadData()
            }, onError: { (Error) in
            }, onCompleted: {
            }) {
        }.disposed(by: self.disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        if let point = touch?.location(in: self.postTableView) {
            if let indexPath = postTableView.indexPathForRow(at: point) {
                let postData = postArray[indexPath.row]
                postService.toggleLike(postData: postData).disposed(by: self.disposeBag)
            }
        }
    }
}

