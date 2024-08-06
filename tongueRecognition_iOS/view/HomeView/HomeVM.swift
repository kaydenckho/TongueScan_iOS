//
//  HomeVM.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/14.
//

import Foundation
import Combine

class HomeVM: ObservableObject {
    
    @Published var uploadImagesResult: UploadImagesResult?
    @Published var uploading: Bool = false
    @Published var uploadFailed: Bool = false
    var images: [ImageModel] = []
    
//    func uploadImage() async {
//        DispatchQueue.main.async {
//            self.uploading = true
//        }
//        Webservice().uploadImage(imageArray: images){ result in
//                switch result{
//                case .success(let model):
//                        DispatchQueue.main.async {
//                            self.uploadImagesResult = model
//                        }
//                    self.uploadFailed = false
//                case .failure(_):
//                    DispatchQueue.main.async {
//                        self.uploadImagesResult = nil
//                    }
//                    self.uploadFailed = true
//                }
//            DispatchQueue.main.async {
//                self.uploading = false
//            }
//        }
//    }
}
