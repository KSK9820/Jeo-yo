//
//  ImageTextRecognizer.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import UIKit
import Combine
import Vision

final class ImageTextRecognizer {
    
    func recognizeText(_ imageData: Data?) -> Future<String, Error> {
        return Future { promise in
            guard let imageData = imageData,
                  let image = UIImage(data: imageData),
                  let cgImage = image.cgImage
            else {
                promise(.failure(RecognizeError.noImage))
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    promise(.failure(RecognizeError.unknown(description: error.localizedDescription)))
                    return
                }
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    promise(.failure(RecognizeError.noText))
                    return
                }
                
                let text = observations.compactMap {
                       $0.topCandidates(1).first?.string
                   }.joined(separator: "\n")
                if text.isEmpty {
                    promise(.failure(RecognizeError.noText))
                }

                promise(.success(text))
            }
            
            if #available(iOS 16.0, *) {
                request.revision = VNRecognizeTextRequestRevision3
                request.recognitionLevel = .accurate
                request.recognitionLanguages =  ["ko-KR"]
                request.usesLanguageCorrection = true
            } else {
                request.recognitionLanguages = ["en-US"]
                request.usesLanguageCorrection = true
            }
            
            do {
                try handler.perform([request])
            } catch {
                promise(.failure(RecognizeError.unknown(description: error.localizedDescription)))
            }
        }
    }
    
}
