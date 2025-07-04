//
//  MainCameraView.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import SwiftUI

struct MainCameraView: View {

    @StateObject var viewModel: CameraViewModel

    var body: some View {
        ZStack {
            CameraView(didCaptureImage: { data in
                guard let image = UIImage(data: data) else {
                    print("image yok")
                    return
                }
                viewModel.detectPerson(with: image)
            })
            
            if viewModel.showCustomAlert , let alertImage = viewModel.customAlertImage {
                Color.secondary
                
                CustomAlertView(image: alertImage) {
                    viewModel.showCustomAlert.toggle()
                } keepButtonClicked: {
                    guard let imageData = alertImage.jpegData(compressionQuality: 0.5) else {
                        return
                    }
                    viewModel.showCustomAlert.toggle()
                    viewModel.saveListModel(ListModel(imageData: imageData, date: Date().currentDateString(), isPersonDetected: true))
                    
                }

                    
            }

        }


            .alert("HATA", isPresented: $viewModel.showErrorAlert, actions: {

        })
            .alert("Kayıt Başarılı", isPresented: $viewModel.showSuccessAlert) {

        }
    }
}

