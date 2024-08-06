//
//  YoloUtil.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 8/9/2023.
//

import Foundation
import Vision
import UIKit

class YoloUtil{
    
    static let shared = YoloUtil()
    
    struct Detection {
        let box:CGRect
        let confidence:Float
    }
    
    var classes:[String] = []
    
    func getYoloRequest() -> VNCoreMLRequest! {
        do {
            let model = try v8().model
            guard let classLabels = model.modelDescription.classLabels as? [String] else {
                fatalError()
            }
            classes = classLabels
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch {
            fatalError("Init model error")
        }
    }
    
    func detect(image: CGImage) -> [Detection]? {
        do {
            let yoloRequest = getYoloRequest()!
            let handler = VNImageRequestHandler(cgImage: image)
            try handler.perform([yoloRequest])
            guard let results = yoloRequest.results as? [VNRecognizedObjectObservation] else {
                return nil
            }
            var detections:[Detection] = []
            for result in results {
                let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                let box = VNImageRectForNormalizedRect(flippedBox, Int(image.width), Int(image.height))
                let detection = Detection(box: box, confidence: result.confidence)
                detections.append(detection)
            }
            return detections
        } catch {
            return nil
        }
    }
    
    
    
}


