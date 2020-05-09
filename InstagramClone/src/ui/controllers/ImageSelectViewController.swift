//
//  ImageSelectViewController.swift
//  InstagramClone
//
//  Created by 堀知海 on 2020/05/06.
//  Copyright © 2020 umichan. All rights reserved.
//

import UIKit
import SVProgressHUD
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleClickLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        } else {
            SVProgressHUD.showError(withStatus: "ライブラリが起動できません。")
        }
    }
    
    @IBAction func handleClickCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           let pickerController = UIImagePickerController()
           pickerController.delegate = self
           pickerController.sourceType = .camera
           self.present(pickerController, animated: true, completion: nil)
        } else {
            SVProgressHUD.showError(withStatus: "カメラが起動できません。")
        }
    }
    
    @IBAction func handleClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let editor = CLImageEditor(image: image) {
                editor.delegate = self
                picker.present(editor, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        if let postViewController = self.storyboard?.instantiateViewController(identifier: "Post") as? PostViewController {
            editor.present(postViewController, animated: true, completion: nil)
        }
    }
    
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
