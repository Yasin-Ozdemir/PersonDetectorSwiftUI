//
//  CameraViewModel.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import Foundation

protocol CameraViewModelProtocol {
    func saveListModel(_ model : ListModel)
}

final class CameraViewModel: CameraViewModelProtocol, ObservableObject {
    @Published var showSuccessAlert : Bool = false
    private let databaseManager: DatabaseManagerProtocol
    
    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }
    
    func saveListModel(_ model : ListModel){
        Task{
            do {
                try await databaseManager.save(model)
                DispatchQueue.main.async {
                    self.showSuccessAlert = true
                }
            } catch{
                print(error)
            }
          
        }
        
    }
}
