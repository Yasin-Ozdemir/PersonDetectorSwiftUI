//
//  DatabaseManager.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import Foundation
import RealmSwift

enum DatabaseError : Error {
    case getAllFailed
    case saveFailed
    case deleteFailed
}

protocol DatabaseManagerProtocol{
    func save<T: Object>(_ object : T) async throws
    func delete<T: Object>(model : T.Type ,  id : ObjectId) async throws
    func getObjects<T: Object>(model: T.Type, lastDate: Date?, pageSize: Int) throws -> [T]
}

final class DatabaseManager: DatabaseManagerProtocol {

        
    func getObjects<T: Object>(model: T.Type, lastDate: Date?, pageSize: Int) throws -> [T] {
        // Results lazy tabanlıdır.

        let realm = try Realm()
        var result: Results<T>

        if let lastDate {
            result = realm.objects(model).filter("date < %@", lastDate).sorted(byKeyPath: "date", ascending: false)
            
        } else {
            result = realm.objects(model).sorted(byKeyPath: "date", ascending: false)
        }

        let page = Array(result.prefix(pageSize))
        return page
    }

    
    func save<T: Object>(_ object : T) async throws {
        
        try await withCheckedThrowingContinuation { continuation in
            do {
             let realm =   try Realm()
               try realm.write {
                   realm.add(object)
                   print("save success")
                }
                continuation.resume()
            }catch{
                continuation.resume(throwing: DatabaseError.saveFailed)
            }
        }
    }
    
    
    func delete<T: Object>(model : T.Type ,  id : ObjectId) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>)  in
            do {
                let realm =   try Realm()
                guard let object = realm.object(ofType: model, forPrimaryKey: id) else {
                    continuation.resume(throwing: DatabaseError.deleteFailed)
                    return
                }
                
                try realm.write {
                    realm.delete(object)
                    print("delete success")
                }
                continuation.resume()
            }catch{
                continuation.resume(throwing: DatabaseError.deleteFailed)
            }
        }
    }
    
    
}
