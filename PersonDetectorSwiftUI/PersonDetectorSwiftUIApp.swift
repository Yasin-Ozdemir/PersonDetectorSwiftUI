//
//  PersonDetectorSwiftUIApp.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import SwiftUI

@main
struct PersonDetectorSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            
            ListView(viewModel: ListViewModel(databaseManager: DatabaseManager()))
        }
    }
}
/*Task(priority: .userInitiated) {
            let startTime = Date()
            print("başladı")

            let realm = try! Realm()
            let imageData = UIImage(resource: .test).jpegData(compressionQuality: 0.5)!
            var batch: [ListModel] = []

            for i in 0..<13000 {
                let bool = Bool.random()
                let model = ListModel(date: Date(), imageData: imageData, isPersonDetected: bool)
                batch.append(model)

                if batch.count == 1000 {
                    try! realm.write {
                        realm.add(batch)
                    }
                    batch.removeAll(keepingCapacity: true)
                }
            }

            // Kalan kayıtları da ekle
            if !batch.isEmpty {
                try! realm.write {
                    realm.add(batch)
                }
            }

            let endTime = Date()
            print("Süre: \(endTime.timeIntervalSince(startTime)) saniye")
 */
 
 /*
 func deleteRealmFiles(fileURL: URL) {
     let fileManager = FileManager.default

     let realmURLs = [
         fileURL,
         fileURL.appendingPathExtension("lock"),
         fileURL.appendingPathExtension("note"),
         fileURL.appendingPathExtension("management")
     ]

     for url in realmURLs {
         do {
             if fileManager.fileExists(atPath: url.path) {
                 try fileManager.removeItem(at: url)
                 print("✅ Silindi: \(url.lastPathComponent)")
             }
         } catch {
             print("❌ Hata silinirken: \(url.lastPathComponent) – \(error)")
         }
     }
 }
 
 
 
 
 
 /*if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
 deleteRealmFiles(fileURL: fileURL)
 }*/
        }*/
