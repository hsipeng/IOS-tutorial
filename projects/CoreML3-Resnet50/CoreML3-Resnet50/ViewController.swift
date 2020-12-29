//
//  ViewController.swift
//  CoreML3-Resnet50
//
//  Created by 彭熙 on 2020/12/29.
//  Copyright © 2020 彭熙. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scene: UIImageView!
    var answerLabel: UILabel!
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // 初始化
        scene = UIImageView()
        answerLabel = UILabel()
        scene.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: 400)
        answerLabel.frame = CGRect(x: 0, y: 444, width: self.view.frame.width, height: 100)
        // 设置label 样式
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.baselineAdjustment = .alignBaselines
        answerLabel.numberOfLines = 6
        
        guard let image = UIImage(named: "scenery") else {
          fatalError("no starting image")
        }
        
        scene.image = image
        
        // 添加到view层
        self.view.addSubview(scene)
        self.view.addSubview(answerLabel)
        
        guard let ciImage = CIImage(image: image) else {
          fatalError("couldn't convert UIImage to CIImage")
        }
        
        // 分类
        imageClassify(image: ciImage)
        
        // 替换图片按钮
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width:200, height: 50))
        btn.setTitle("Change image", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.black
        btn.addTarget(self, action: #selector(self.pickImage(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
    }


    @objc func pickImage(_ sender: Any) {
        // imagePicker 选择图片
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
    
    // MARK: - 分类
    func imageClassify(image: CIImage) {
      answerLabel.text = "detecting..."
    
      // 通过生成模型的类来加载机器学习模型
      guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
        fatalError("can't load Places ML model")
      }
      
      // 创建视觉模型请求，附带完成时的回调句柄
      let request = VNCoreMLRequest(model: model) { [weak self] request, error in
        let results = request.results as? [VNClassificationObservation]

        var outputText = ""
        
        for res in results!{
          outputText += "\(Int(res.confidence * 100))% it's \(res.identifier)\n"
        }
        DispatchQueue.main.async { [weak self] in
          self?.answerLabel.text! = outputText
        }
      }
      
      // 在全局派发队列中运行CoreML3 Resnet50分类模型
      let handler = VNImageRequestHandler(ciImage: image)
      DispatchQueue.global(qos: .userInteractive).async {
        do {
          try handler.perform([request])
        } catch {
          print(error)
        }
      }

    }
    
   // MARK: - 图片选择回掉
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
        fatalError("couldn't load image from Photos")
      }
        
      scene.image = image
      
      guard let ciImage = CIImage(image: image) else {
        fatalError("couldn't convert UIImage to CIImage")
      }

      imageClassify(image: ciImage)
      self.scene.contentMode = .scaleAspectFill
      self.imagePicker.delegate = nil
      picker.dismiss(animated: true)
    }
}
