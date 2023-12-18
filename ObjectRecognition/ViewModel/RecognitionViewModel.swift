//
//  RecognitionViewModel.swift
//  ObjectRecognition
//
//  Created by Tony Santiago on 17/12/23.
//

import SwiftUI
import CoreML
import Vision

class RecognitionViewModel: ObservableObject {
    @Published var recognizedObject = RecognitionResult(identifier: "Nenhum objeto reconhecido")
    @Published var identifiedObject = RecognitionResult(identifier: "")

    func recognizeObject(image: UIImage?) {
        
        clearResults()
        
        guard let image = image, let ciImage = CIImage(image: image) else {
            print("Erro ao converter a imagem.")
            return
        }

        guard let model = loadMobileNetV2Model() else {
            print("Erro ao carregar o modelo.")
            return
        }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let bestResult = results.first else {
                return
            }
            DispatchQueue.main.async {
                let recognitionResult = RecognitionResult(identifier: bestResult.identifier)
                self?.identifiedObject = recognitionResult
                self?.recognizedObject = recognitionResult
                print("Objeto reconhecido: \(bestResult.identifier)")
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print("Erro ao realizar a previsão: \(error.localizedDescription)")
        }
    }
    
    func clearResults() {
        recognizedObject = RecognitionResult(identifier: "Nenhum objeto reconhecido")
        identifiedObject = RecognitionResult(identifier: "")
    }

    private func loadMobileNetV2Model() -> VNCoreMLModel? {
        do {
            let configuration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: MobileNetV2(configuration: configuration).model)
            return model
        } catch {
            print("Erro ao carregar o modelo MobileNetV2: \(error.localizedDescription)")
            return nil
        }
    }
}
