//
//  PostTableViewCell.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/13.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    private let postService = PostService(
        userRepository: FirebaseUserRepository(),
        postRepository: FirebasePostRepository(),
        imageRepository: FirebaseImageRepository()
    )

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.postService.fetchPostImage(fileName: postData.fileName)
            .subscribe(onNext: { (imageRef: AnyObject) in
                if (imageRef is StorageReference) {
                    self.postImageView.sd_setImage(with: imageRef as! StorageReference)
                }
            }, onError: { (Error) in
            }, onCompleted: {
            }) {
            }
        
        self.captionLabel.text = "\(postData.name ?? "") : \(postData.caption ?? "")"

        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        self.likeLabel.text = "\(postData.likes.count)"
        
        if postData.isLiked {
            self.likeButton.setImage(UIImage(named: "like_exist"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "like_none"), for: .normal)
        }
    }
}
