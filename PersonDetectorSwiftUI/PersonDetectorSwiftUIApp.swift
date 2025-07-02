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
