//
//  PersonDetectorManager.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import Foundation
import TensorFlowLite

enum PersonDetectorError : Error {
    case failedToDetectPerson
    case noPersonDetected
}
protocol PersonDetectorManagerProtocol {
    func detectPerson(with image: UIImage) async -> Result<DetectedModel , Error>
}

final class PersonDetectorManager: PersonDetectorManagerProtocol {
    private var interpreter: Interpreter?
    private var inputWidth: CGFloat
    private var inputHeight: CGFloat
    private var confidenceThreshold: Float

    init(inputWidth: CGFloat, inputHeight: CGFloat, confidenceThreshold: Float) {
        self.inputWidth = inputWidth
        self.inputHeight = inputHeight
        self.confidenceThreshold = confidenceThreshold
        setupYolo()
    }

    private func setupYolo() {
        guard let modelPath = Bundle.main.path(forResource: "person-det 1", ofType: "tflite") else {
            print("model yok knk")
            return
        }
        var options = Interpreter.Options()
        options.threadCount = 2

        do {
            interpreter = try Interpreter(modelPath: modelPath, options: options)
            try interpreter?.allocateTensors()
        } catch {
            print("model error")
        }
    }

    
    func detectPerson(with image: UIImage) async -> Result<DetectedModel , Error> {
        
        await withCheckedContinuation { continuation  in
            guard let inputImage = configureImage(image), let inputData = inputImage.getRgbData(), let interpreter else {
                 continuation.resume(returning: .failure(PersonDetectorError.failedToDetectPerson))
                return
            }

            do {
                try interpreter.copy(inputData, toInputAt: 0)
                try interpreter.invoke()

                let boxes = try interpreter.output(at: 0).data.toArray(type: Float.self)
                let confidences = try interpreter.output(at: 1).data.toArray(type: Float.self)
                
                let detections : [Detection] = self.filterDetections(boxes: boxes, confidences: confidences)
                
                guard !detections.isEmpty else {
                     continuation.resume(returning: .failure(PersonDetectorError.noPersonDetected))
                    return
                }
                
               let finalDetections : [Detection] = self.nonMaximumSuppression(detections: detections)
                
                 continuation.resume(returning: .success(DetectedModel(image: inputImage, box: finalDetections.first!.boundingBox)))
                
            } catch {
                 continuation.resume(returning: .failure(PersonDetectorError.failedToDetectPerson))
            }
         }
       
    }

    
    private func filterDetections(boxes : [Float], confidences : [Float]) -> [Detection]{
        let detections : [Detection] = confidences.lazy.enumerated().filter{$1 > confidenceThreshold}.map { index, confidence in
            let box =  Array(boxes[index * 4..<index * 4 + 4])
            
            let x = CGFloat(box[0])
            let y = CGFloat(box[1])
            let width = CGFloat(box[2] - box[0])
            let height = CGFloat(box[3] - box[1])
            
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            return Detection(confidenceScore: confidence, boundingBox: rect)
        }
        
        return detections
    }
    
    
    private func configureImage(_ image: UIImage) -> UIImage? {
        let image = image.upright()

        guard let resizedImage = image.resize(to: CGSize(width: inputWidth, height: inputHeight)) else {
            return nil
        }
        return resizedImage
    }
    
    
    private func nonMaximumSuppression(detections: [Detection], iouThreshold: Float = 0.3) -> [Detection] {
        var sorted = detections.sorted { $0.confidenceScore > $1.confidenceScore }
        
        var result : [Detection] = []
         
        while !sorted.isEmpty {
            let best = sorted.removeFirst()
            result.append(best)

            sorted = sorted.filter {
                iou($0.boundingBox, best.boundingBox) < iouThreshold
            }
        }
        return result
    }

    
    private func iou(_ a: CGRect, _ b: CGRect) -> Float {
        let intersection = a.intersection(b)
        let intersectionArea = intersection.width * intersection.height
        let unionArea = a.width * a.height + b.width * b.height - intersectionArea
        return Float(intersectionArea / unionArea)
    }
}
