//
//  Date+Ext.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//
import Foundation

extension Date {
    func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
