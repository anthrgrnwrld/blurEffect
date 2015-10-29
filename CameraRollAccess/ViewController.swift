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
    
    private var effectView : UIVisualEffectView!                //Effect用View
    
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
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
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
    
    /*
    エフェクトを適用する.
    */
    internal func addVirtualEffectView(effect : UIBlurEffect!){
        
        if effectView != nil {
            effectView.removeFromSuperview()
        }
        
        // Blurエフェクトを適用するEffectViewを作成.
        effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRectMake(0, 0, 360, 200)
        effectView.center = imageFromCameraRoll.center
        effectView.layer.masksToBounds = true
        effectView.layer.cornerRadius = 20.0
        imageFromCameraRoll.addSubview(effectView)
    }
    
    /*
    blur Effectメソッド
    
    :param: effectIndex:effect用Index
    */
    func onClickMySegmentedControl(effectIndex: Int){
        
        var effect : UIBlurEffect!
        
        switch effectIndex {
            
        case 0:
            print("No effect")
            
        case 1:
            // LightなBlurエフェクトを作る.
            effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            
        case 2:
            // ExtraLightなBlurエフェクトを作る.
            effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            
            
        case 3:
            // DarkなBlurエフェクトを作る.
            effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            
        default:
            print("Error")
        }
        
        self.addVirtualEffectView(effect)
    }

    /*
    EffectSegControlを押したら呼ばれるメソッド
    */
    @IBAction func pressEffectSegControl(sender: AnyObject) {
        
        onClickMySegmentedControl(effectSegControl.selectedSegmentIndex)    //blurEffect実行
        
    }

}

