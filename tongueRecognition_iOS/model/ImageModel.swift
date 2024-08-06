//
//  Image.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 14/8/2023.
//

import Foundation

struct ImageModel:Codable, Hashable{
    var originalImg: Data?
    var croppedImg: Data?
    var filename: String
}
