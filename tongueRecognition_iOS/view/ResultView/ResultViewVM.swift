//
//  ResultViewVM.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 14/3/2024.
//

import Foundation
import SwiftUI

class ResultViewVM: ObservableObject {
    
    @Published var isSavedPhoto = false
    @Published var showSavedPhotoAlert = false
    
    @Published var resultImage: Data? = nil
    
    func saveImage(){
        if let resultImage{
            Task{
                UIImageWriteToSavedPhotosAlbum(UIImage(data: resultImage)!, nil, nil, nil)
            }
            self.isSavedPhoto.toggle()
        }
    }

    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
