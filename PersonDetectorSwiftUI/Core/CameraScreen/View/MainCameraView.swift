//
//  MainCameraView.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import SwiftUI

struct MainCameraView: View {
    
    
    @StateObject var viewModel : CameraViewModel
    
    var body: some View {
        CameraView(didCaptureImage: { data in
            viewModel.saveListModel(ListModel(imageData: data, date: Date().currentDateString(), isPersonDetected: false))
        })
        .alert("Save Success", isPresented: $viewModel.showSuccessAlert) {
                
            }
    }
}

