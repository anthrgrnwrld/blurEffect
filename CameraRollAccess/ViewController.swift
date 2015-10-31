//
//  ViewController.swift
//  CameraRollAccess
//
//  Created by Masaki Horimoto on 2015/10/26.
//  Copyright © 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageFromCameraRoll: UIImageView!        //写真表示用のUIImageView
    @IBOutlet weak var effectSegControl: UISegmentedControl!    //Effect選択用SegControl
    
    private var effectView : UIVisualEffectView?                //Effect用View
    
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
        
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else {
            return
        }
        
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
        defer {
            //写真選択後にカメラロール表示ViewControllerを引っ込める動作
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報が入っている？)をUIImageにCastする
        guard let originalImage = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //そしてそれを宣言済みのimageViewへ放り込む
        imageFromCameraRoll.image = originalImage
    }

    /**
    カメラロールボタンを押した時
    */
    @IBAction func pressCameraRoll(sender: AnyObject) {
        
        pickImageFromLibrary()  //ライブラリから写真を選択する
        
    }
    
    /*
    エフェクトを適用する.
    */
    internal func addVirtualEffectView(effect : UIBlurEffect?){
        
        effectView?.removeFromSuperview()
        effectView = nil
        
        guard let ef = effect else {
            return
        }
        
        // Blurエフェクトを適用するEffectViewを作成.
        effectView = UIVisualEffectView(effect: ef)
        guard let ev = effectView else {
            return
        }
        
        ev.frame = CGRectMake(0, 0, 360, 200)
        ev.center = imageFromCameraRoll.center
        ev.layer.masksToBounds = true
        ev.layer.cornerRadius = 20.0
        imageFromCameraRoll.addSubview(ev)
    }
    
    /*
    blur Effectメソッド
    
    :param: effectIndex:effect用Index
    */
    func onClickMySegmentedControl(effectIndex: Int){
        let styles : [UIBlurEffectStyle?] = [nil, .Light, .ExtraLight, .Dark]
        let style = styles[effectIndex]
        let effect = style.map{ UIBlurEffect(style: $0) }
        self.addVirtualEffectView(effect)
    }

    /*
    EffectSegControlを押したら呼ばれるメソッド
    */
    @IBAction func pressEffectSegControl(sender: AnyObject) {
        
        onClickMySegmentedControl(effectSegControl.selectedSegmentIndex)    //blurEffect実行
        
    }

}

