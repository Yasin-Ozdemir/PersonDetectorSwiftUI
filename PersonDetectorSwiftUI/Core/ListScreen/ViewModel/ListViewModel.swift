//
//  ListViewModel.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import Foundation
import RealmSwift
import UIKit
protocol ListViewModelProtocol: ObservableObject {
    func deleteListModel(with id : ObjectId)
}
final class ListViewModel: ListViewModelProtocol {
    
    private var databaseManager: DatabaseManagerProtocol

    private var listModelsTemp: [ListModel] = []
    private var isFiltered : Bool = false
    private var lastDate : Date?
    private var moreData : Bool = true
    
    @Published var listModels: [ListModel] = []
    @Published var showCameraView: Bool = false
    @Published var showDeleteAlert: Bool = false
    
    private var notificationToken: NotificationToken?

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .photoSaved, object: nil)
        fetchListModelsWithPagination()
        
    }

    
    func fetchListModelsWithPagination(){
        let startTime = Date()
        guard moreData , !isFiltered else { return }
        do {
            let objects = try databaseManager.getObjects(model: ListModel.self, lastDate: lastDate, pageSize: 20)
            
            guard !objects.isEmpty else {
                moreData.toggle()
                return
            }
            
            self.lastDate = objects.last?.date
            self.listModels.append(contentsOf: objects)
            let endTime = Date()
            print("Görünme Süresi: \(endTime.timeIntervalSince(startTime)) saniye") // 0.048 - 0.050 civarı görünme süresi ama scroll ettikçe ram yine şişiyor
        }catch{
            print("pagination error")
        }
    }
    

    func deleteListModel(with id : ObjectId) {
        Task {
            do {
                try await databaseManager.delete(model: ListModel.self, id: id)
               
                await MainActor.run {
                 // listModelsden kaldır
                    self.showDeleteAlert.toggle()
                }
                  
            } catch {
                print(error)
            }

        }
    }
    
    
    func filterListModel(){
        if !isFiltered {
            self.listModelsTemp = listModels
            self.listModels = listModels.filter{$0.isPersonDetected}
        }else {
            self.listModels = listModelsTemp
        }
        isFiltered.toggle()
    }
    
    @objc func reload(){
        DispatchQueue.main.async{
            self.listModels = []
            self.moreData = true
            self.lastDate = nil
            self.fetchListModelsWithPagination()
        }
    }
 
}
