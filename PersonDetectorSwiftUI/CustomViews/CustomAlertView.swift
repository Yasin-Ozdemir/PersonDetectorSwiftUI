//
//  CustomAlertView.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 4.07.2025.
//

import SwiftUI

struct CustomAlertView: View {
    private let title: String = "Person has been detected."
    private let bodyText: String = "If you keep this image, information will be logged in your visit."
    private let image: UIImage
    private let removeButtonClicked: () -> Void
    private let keepButtonClicked: () -> Void
    
    init(image: UIImage, removeButtonClicked: @escaping () -> Void , keepButtonClicked: @escaping () -> Void) {
        self.image = image
        self.removeButtonClicked = removeButtonClicked
        self.keepButtonClicked = keepButtonClicked
    }
    
    var body: some View {
        VStack{
            Text(title)
                .font(.headline)
            Text(bodyText)
                .font(.subheadline)
            
            Image(uiImage: image)
                .resizable()
                .frame(width: 300, height: 450)
            
            Button("Remove Image") {
               removeButtonClicked()
            }.padding(.vertical)
            
            Button("Keep Image") {
               keepButtonClicked()
            }.padding(.vertical)
        }
        .padding()
        .background(Color.black)
        .shadow(radius: 10)
    }
}


