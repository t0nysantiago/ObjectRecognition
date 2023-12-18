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
    @Published var recognizedObject = "Nenhum objeto reconhecido"
    @Published var identifiedObject = ""

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
                self?.identifiedObject = bestResult.identifier
                self?.recognizedObject = bestResult.identifier
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
        recognizedObject = "Nenhum objeto reconhecido"
        identifiedObject = ""
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
