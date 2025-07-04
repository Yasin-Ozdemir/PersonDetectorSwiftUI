//
//  CameraViewModel.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import Foundation
import UIKit
protocol CameraViewModelProtocol {
    func saveListModel(_ model: ListModel)
    func detectPerson(with image: UIImage)
}

final class CameraViewModel: CameraViewModelProtocol, ObservableObject {
    @Published var showSuccessAlert: Bool = false // variable sync
    @Published var showErrorAlert: Bool = false
    @Published var showCustomAlert: Bool = false
    @Published var customAlertImage: UIImage?

    private let databaseManager: DatabaseManagerProtocol
    private let personDetectorManager: PersonDetectorManagerProtocol
    private let yoloInputSize: CGSize = CGSize(width: 640, height: 640)
    init(databaseManager: DatabaseManagerProtocol, personDetectorManager: PersonDetectorManagerProtocol) {
        self.databaseManager = databaseManager
        self.personDetectorManager = personDetectorManager
    }

    func saveListModel(_ model: ListModel) {
        Task(priority: .high) {
            do {
                try await databaseManager.save(model)

                await MainActor.run {
                    self.showSuccessAlert.toggle()
                }

            } catch {
                print(error)
            }
        }
    }

    func detectPerson(with image: UIImage) {
        Task(priority: .userInitiated) {
            let result = await personDetectorManager.detectPerson(with: image)

            switch result {
            case .success(let detectedModel):
                await MainActor.run { // main threadde çalışacağı garantidir, self başka threadlerler paylaşılmaz. Race condition riski yok.

                    
                    let originalRect = detectedModel.box.calculate(for: image.size, currentSize: self.yoloInputSize)
                    
                    guard let resizedImage = detectedModel.image.resize(to: image.size), let bluredImage = resizedImage.blur(rect: originalRect, level: .mid) else {
                        self.showErrorAlert.toggle()
                        return
                    }
                    
                    self.customAlertImage = bluredImage
                    self.showCustomAlert.toggle()


                }
            case .failure(let failure):
                if failure as? PersonDetectorError == PersonDetectorError.noPersonDetected {

                    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                        return
                    }

                    self.saveListModel(ListModel(imageData: imageData, date: Date().currentDateString(), isPersonDetected: false))
                } else {
                    self.showErrorAlert.toggle()
                }
            }
        }

    }

}
