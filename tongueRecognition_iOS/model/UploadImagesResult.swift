//
//  UploadImagesResult.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/14.
//

import Foundation

struct UploadImagesResult:Codable{
    var result: ResultArray?
    var image: String?
    var image_name: String?
}

struct ResultArray:Codable{
    var index: String?
    var tontue_color_description: String?
    var tontue_color_description_explain: String?
    var coating_color_description: String?
    var coating_color_description_explain: String?
    var think_coating_description: String?
    var think_coating_description_explain: String?
    var greasy_coating_description: String?
    var greasy_coating_description_explain: String?
    var diabetes_tongue_description: String?
    var diabetes_prob: String?
    var diabetes_tongue_description_explain: String?
}
