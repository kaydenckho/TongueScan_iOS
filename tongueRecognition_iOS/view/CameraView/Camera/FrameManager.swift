/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import AVFoundation
import UIKit


class FrameManager: NSObject, ObservableObject {
  
  @Published var current: CVPixelBuffer?
  @Published var capturedPhoto: CGImage?
    var captureCallback: (CGImage)->() = {cgImage in }
    var captureCallbackFlash: (CGImage)->() = {cgImage in }
  
  let videoOutputQueue = DispatchQueue(
    label: "com.pickle.VideoOutputQ",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem)
  
  let photoCaptureOutputQueue = DispatchQueue(
    label: "com.pickle.PhotoCaptureOutputQ",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem
  )
    
}

extension FrameManager: AVCapturePhotoCaptureDelegate {
    
    func takePicture(flashMode: AVCaptureDevice.FlashMode) {
        CameraManager.shared.takePicture(self, queue: photoCaptureOutputQueue, flashMode: flashMode)
  }
  
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
            AudioServicesDisposeSystemSoundID(1108)
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
            AudioServicesDisposeSystemSoundID(1108)
    }
    
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let imageData = photo.fileDataRepresentation() {
      
      guard let newImage = UIImage(data: imageData) else { return }
    
      guard let cgImage = newImage.cgImage else { return }
      DispatchQueue.main.async {
          self.capturedPhoto = cgImage
          if (photo.resolvedSettings.isFlashEnabled){
              self.captureCallbackFlash(cgImage)
          } else{
              self.captureCallback(cgImage)
          }
      }
        
    }
  }
    

}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    if let buffer = sampleBuffer.imageBuffer {
      DispatchQueue.main.async {
        self.current = buffer
      }
    }
  }
}
