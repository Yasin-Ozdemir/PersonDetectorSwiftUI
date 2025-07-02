//
//  ListViewModel.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import Foundation
import RealmSwift
protocol ListViewModelProtocol: ObservableObject {
   
}
final class ListViewModel: ListViewModelProtocol {
    private var databaseManager: DatabaseManagerProtocol
    @Published var listModels: [ListModel] = []
    @Published var showCameraView: Bool = false
    @Published var showDeleteAlert: Bool = false
    private var notificationToken: NotificationToken?

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
        setupObservations()
    }

    private func setupObservations() {

        let results = databaseManager.getAll(model: ListModel.self)

        switch results {

        case .success(let objects):
            self.notificationToken = objects.observe({ [weak self] changes in
                guard let self else {
                    return
                }
                switch changes {

                case .initial(let objects):
                    self.listModels = Array(objects)

                case .update(let objects, deletions: _, insertions: _, modifications: _):
                    self.listModels = Array(objects)

                case .error(let error):
                    print(error.localizedDescription)
                }
            })

        case .failure(let error):
            print (error.localizedDescription)
        }

    }


    func deleteListModel(with id : ObjectId) {
        
        Task {
            do {
                try await databaseManager.delete(model: ListModel.self, id: id)
                DispatchQueue.main.async {
                    self.showDeleteAlert.toggle()
                }
                
            } catch {
                print(error)
            }

        }
    }

}
