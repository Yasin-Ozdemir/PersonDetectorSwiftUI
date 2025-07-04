//
//  CameraView.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import SwiftUI

protocol CameraDelegate: AnyObject {
    func didCaptureImage(_ imageData: Data)
}

struct CameraView: UIViewControllerRepresentable {
  
    private let didCaptureImage : (Data) -> Void
    
    init( didCaptureImage : @escaping (Data) -> Void) {
        self.didCaptureImage = didCaptureImage
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
   func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: CameraDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func didCaptureImage(_ imageData: Data) {
            parent.didCaptureImage(imageData)
        }
       
    }
}
