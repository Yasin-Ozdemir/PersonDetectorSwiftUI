//
//  ListViewItem.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import SwiftUI

struct ListViewItem: View {
    let listModel : ListModel?
    var onRemove : () -> Void
    var body: some View {
        if let listModel {
            content(for: listModel)
        }else {
            EmptyView()
        }
       
    }
    
    func getImage(with data : Data?) -> UIImage {
        guard let data  , let uiImage = UIImage(data: data) else {
           return UIImage(resource: .test)
        }
        return uiImage
    }
}

extension ListViewItem {
    private func content(for model: ListModel) -> some View {
        VStack {
            Image(uiImage: getImage(with: model.imageData))
                .resizable()
                .frame(width: 140, height: 200)
                .padding(.horizontal, 8)
                .padding(.top , 8)

            Text(model.date)
                .font(.system(size: 15, weight: .semibold))
        }
        .contextMenu(menuItems: {
            Button {
                self.onRemove()
            } label: {
                Text("Remove")
            }

        })
        .background(
            (model.isPersonDetected ? Color.red.opacity(0.4) : Color.primary.opacity(0.1))
                .cornerRadius(10)
        )
    }
}


