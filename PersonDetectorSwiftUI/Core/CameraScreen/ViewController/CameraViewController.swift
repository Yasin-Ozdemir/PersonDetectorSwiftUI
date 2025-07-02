//
//  CameraViewController.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 2.07.2025.
//

import UIKit
import AVFoundation
protocol CustomCameraDelegate: AnyObject {
    func didCaptureImage(_ imageData: Data)
}
class CameraViewController: UIViewController {
    weak var delegate: CustomCameraDelegate?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var session: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
   
    
    private let cameraPreviewView = UIView()
    private let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(tappedCapture), for: .touchUpInside)
        return button
    }()

    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .label
        return button
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .secondaryLabel
        button.setTitleColor(.secondarySystemBackground, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()

    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Restart", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        addSubviews(views: [cameraPreviewView  , captureButton , doneButton , restartButton , settingsButton])
        applyConstraints()
        checkCameraPermission()
    }
    
    
    private func addSubviews(views : [UIView]) {
        views.forEach { view in
            self.view.addSubview(view)
        }
    }


    private func applyConstraints() {
        cameraPreviewView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cameraPreviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraPreviewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cameraPreviewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraPreviewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 60),
            captureButton.heightAnchor.constraint(equalToConstant: 60),

            settingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            settingsButton.widthAnchor.constraint(equalToConstant: 90),
            settingsButton.heightAnchor.constraint(equalToConstant: 60),

            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            restartButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 40),
            restartButton.widthAnchor.constraint(equalToConstant: 90),

            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.widthAnchor.constraint(equalToConstant: 60),
            ])
    }
    
    
    private func checkCameraPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                granted ? self.setupCamera() : self.showPermissionAlert()
            })
            
        case .restricted , .denied:
            self.showPermissionAlert()
     
        case .authorized:
            self.setupCamera()
            
        @unknown default: break
            
        }
    }
    
    
    private func setupCamera(){
        
        self.session = AVCaptureSession()
        self.photoOutput = AVCapturePhotoOutput()
        
        session.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: camera), session.canAddInput(input) else {
            return
        }
        
        session.addInput(input)
        
        guard session.canAddOutput(photoOutput) else {
            return
        }
        
        session.addOutput(photoOutput)
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            self.previewLayer.frame = self.view.bounds
        }
        
        cameraPreviewView.layer.addSublayer(previewLayer)
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
        
    }
       
    
    @objc private func tappedCapture() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func showPermissionAlert(){
        let alert = UIAlertController(title: "Camera Permission Required", message: "Please allow camera access in the settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    
}

extension CameraViewController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        delegate?.didCaptureImage(imageData)
    }
    
}
