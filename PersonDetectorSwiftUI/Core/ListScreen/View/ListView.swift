//
//  ListView.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import SwiftUI

struct ListView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
   
    @StateObject var viewModel: ListViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.listModels) { listModel in
                        ListViewItem(listModel: listModel) {
                            viewModel.deleteListModel(with: listModel._id)
                        }
                    }
                }
            }
            .alert("Delete Success", isPresented: $viewModel.showDeleteAlert, actions: {
                
            })
                .navigationTitle("Person Detector App")
                .toolbar(content: {
                    
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showCameraView.toggle()
                    } label: {
                        Image(systemName: "plus").tint(.primary)
                    }
                }
            })
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $viewModel.showCameraView) {
                    MainCameraView(viewModel: CameraViewModel(databaseManager: DatabaseManager()))
            }
        }
    }
}


