//
//  HomeVM.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/14.
//

import Foundation
import Combine
import SwiftUI
import AVFoundation
import CoreImage

class CameraViewVM: ObservableObject {
    
    @Published var error: Error?
    @Published var frame: CGImage? = nil
    @Published var capturedPhoto: CGImage?
    
    let preferenceUtil = PreferenceUtil()
    
    private let frameManager = FrameManager()

    private let cameraManager = CameraManager.shared
    
    private let yoloUtil = YoloUtil.shared
    
    var speechSynthesizer = AVSpeechSynthesizer()
    
    var semaphore = DispatchSemaphore(value:1)
    var isCapturing = false
    var finished = true
    var isDetecting = true
    @Published var images: [ImageModel] = []
    @Published var showSavedPhotoAlert = false
    @Published var isSavedPhoto = false
    
    func takePicture() {
        isCapturing = true
        speak(msg: "taking_photo")
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd_MMM_yyyy_HH_mm_ss"
        
        frameManager.captureCallback = { cgImage in
            Task{
                let filename = "TongueRecognition_" + dateFormatter.string(from: date)
                self.cropAndAppendImage(filename: filename, cgImage: cgImage)
            }
        }
        
        frameManager.captureCallbackFlash = { cgImage in
            Task{
                let filename = "TongueRecognition_flash_" + dateFormatter.string(from: date)
                self.cropAndAppendImage(filename: filename, cgImage: cgImage)
                self.speak(msg: "take_photo_success")
                self.isCapturing = false
            }
        }

        frameManager.takePicture(flashMode: .off)
        frameManager.takePicture(flashMode: .on)
    }
    
    func cropAndAppendImage(filename: String, cgImage: CGImage){
        let result = self.yoloUtil.detect(image:cgImage)
        var croppedImg = cgImage
        if let result{
            if (result.count > 0){
                croppedImg = cgImage.cropping(to: result[0].box)!
            }
        }
        let croppedImgData = self.rotateImage(cgImage: croppedImg).jpegData(compressionQuality: 0.8)
        let originalImgData = self.rotateImage(cgImage: cgImage).jpegData(compressionQuality: 0.8)
        DispatchQueue.main.async{
            self.images.append(ImageModel(originalImg: originalImgData, croppedImg: croppedImgData, filename: filename))
        }
    }
    
    func rotateImage(cgImage:CGImage) -> UIImage{
        let temp = CIImage(cgImage: cgImage).oriented(forExifOrientation: 6)
        return UIImage(ciImage: temp)
    }
    
    func startCamera(mode: CameraView.Mode) {
        CameraManager.shared.set(frameManager, queue: frameManager.videoOutputQueue)
        cameraManager.start()
            frameManager.$current
                .receive(on: RunLoop.main)
                .compactMap { buffer in
                    let frame = CGImage.create(from: buffer)
                    self.semaphore.wait()
                    if (mode == .Auto && self.finished && self.isDetecting){
                        DispatchQueue.global().async {
                        self.finished = false
                            if let frame{
                                let results = self.yoloUtil.detect(image: self.minimize(img: frame))
                                if let results{
                                    if (results.count > 0){
                                        let rect = results[0].box
                                        let angle = self.calculateAngle(x1: rect.midX, y1: rect.maxY, x2: rect.minX, y2: rect.minY, x3: rect.maxX, y3: rect.minY)
                                        let confidence = results[0].confidence
                                        if (confidence > 0.90 && angle > 60){
                                            self.isDetecting = false
                                            self.takePicture()
                                        }
                                    }
                                }
                            }
                            self.finished = true
                        }
                    }
                    self.semaphore.signal()
                return frame
            }
            .assign(to: &$frame)
            
            
          frameManager.$capturedPhoto
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$capturedPhoto)
          
          cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
    }
    
    func stopCamera(){
        resetCamera()
        cameraManager.stop()
    }
    
    func resetCamera(){
        self.capturedPhoto = nil
        frameManager.capturedPhoto = nil
        frameManager.current = nil
        images.removeAll()
        isDetecting.toggle()
        isSavedPhoto.toggle()
    }
    
    @Published var uploadImagesResult: APIResponse<UploadImagesResult>?
    @Published var uploading: Bool = false
    @Published var uploadSuccess: Bool = false
    @Published var uploadFailed: Bool = false
    
    func uploadImage(token:String) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        var language = "tc"
        switch (preferenceUtil.language){
            case "en": language = "en"
            case "zh-HK": language = "tc"
            case "zh-Hans": language = "zh"
        default: break
        }
        Webservice().uploadImage(imageArray: images, language: language, token: token){ result in
                switch result{
                case .success(let model):
                        DispatchQueue.main.async {
                            self.uploadImagesResult = model
                            if (model?.code == 0){
                                self.uploadSuccess = true
                                if (!self.isSavedPhoto){
                                    self.saveImage()
                                }
                            } else{
                                self.uploadFailed = true
                            }
                        }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.uploadImagesResult = nil
                    }
                    self.uploadFailed = true
                }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }

    func minimize(img:CGImage) -> CGImage{
        let scaledCropArea = CGRect(
            x: Double(img.width) * 0.15,
            y: 0,
            width: Double(img.width) - Double(img.width) * 0.3,
            height: Double(img.height) - Double(img.height) * 0.5
        )
        return img.cropping(to: scaledCropArea)!
    }
    
    func calculateAngle(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat, x3:CGFloat, y3:CGFloat) -> CGFloat{
        let a2 = lengthSquare(x1: x2, y1: y2, x2: x3, y2: y3)
        let b2 = lengthSquare(x1: x1, y1: y1, x2: x3, y2: y3)
        let c2 = lengthSquare(x1: x1, y1: y1, x2: x2, y2: y2)
        let b = sqrt(b2)
        let c = sqrt(c2)
        var alpha = acos((b2 + c2 - a2) / (2 * b * c))
        alpha = alpha * 180 / CGFloat.pi
        return alpha
    }
    
    func lengthSquare(x1:CGFloat,y1:CGFloat,x2:CGFloat,y2:CGFloat) -> CGFloat{
        let xDiff = x1 - x2
        let yDiff = y1 - y2
        return xDiff * xDiff + yDiff * yDiff
    }
    
    func saveImage(){
        Task{
            UIImageWriteToSavedPhotosAlbum(UIImage(data: images[0].originalImg!)!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(UIImage(data: images[1].originalImg!)!, nil, nil, nil)
        }
        isSavedPhoto.toggle()
    }
    
    func speak(msg:String){
        let language = (preferenceUtil.language == "en") ? "en-US" : preferenceUtil.language
        let utterance = AVSpeechUtterance(string: msg.localizedString(language: preferenceUtil.language))
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        speechSynthesizer.speak(utterance)
    }
    
    func touchToFocus(point:CGPoint){
        cameraManager.touchToFocus(point: point)
    }
}
