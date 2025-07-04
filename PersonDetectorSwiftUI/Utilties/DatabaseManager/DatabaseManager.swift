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
    func getAll<T: Object>(model : T.Type) -> Result<Results<T> , Error>
    func save<T: Object>(_ object : T) async throws
    func delete<T: Object>(model : T.Type ,  id : ObjectId) async throws
}

final class DatabaseManager: DatabaseManagerProtocol {

    func getAll<T: Object>(model : T.Type) -> Result<Results<T> , Error>{
        do {
            let realm =  try Realm()
            let objects = realm.objects(model.self)
            print("objeler: " , objects)
            return .success(objects)
        }catch {
            return .failure(error)
        }
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
    
    
    func delete<T: Object>(model : T.Type ,  id : ObjectId ) async throws {
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
