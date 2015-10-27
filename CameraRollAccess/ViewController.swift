//
//  ViewController.swift
//  CameraRollAccess
//
//  Created by Masaki Horimoto on 2015/10/26.
//  Copyright © 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageFromCameraRoll: UIImageView!    //写真表示用のUIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //contentModeを設定
        // http://anthrgrnwrld.hatenablog.com/entry/2015/10/17/123659 参照
        //.ScaleAspectFit
        //.ScaleAspectFill
        //.ScaleToFill
        imageFromCameraRoll.contentMode = .ScaleAspectFit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    ライブラリから写真を選択する
    */
    func pickImageFromLibrary() {

        //写真ライブラリ(カメラロール)表示用のViewControllerを宣言しているという理解
        let controller = UIImagePickerController()
        
        //おまじないという認識で今は良いと思う
        controller.delegate = self
        
        //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
        //以下はカメラロールの例
        //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    /**
    写真を選択した時に呼ばれる (swift2.0対応)
    
    :param: picker:おまじないという認識で今は良いと思う
    :param: didFinishPickingMediaWithInfo:おまじないという認識で今は良いと思う
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String: AnyObject]) {
        
        //このif条件はおまじないという認識で今は良いと思う
        if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
            
            //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報が入っている？)をUIImageにCastする
            //そしてそれを宣言済みのimageViewへ放り込む
            imageFromCameraRoll.image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage


        }
        
        //写真選択後にカメラロール表示ViewControllerを引っ込める動作
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    /**
    カメラロールボタンを押した時
    */
    @IBAction func pressCameraRoll(sender: AnyObject) {
        
        pickImageFromLibrary()  //ライブラリから写真を選択する
        
    }

}

