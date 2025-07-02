//
//  ListModel.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//
import RealmSwift
import Foundation
final class ListModel : Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: String
    @Persisted var imageData : Data
    @Persisted var isPersonDetected : Bool
    
    convenience init(imageData: Data, date: String , isPersonDetected : Bool) {
        self.init()
        self.imageData = imageData
        self.date = date
        self.isPersonDetected = isPersonDetected
    }
}
