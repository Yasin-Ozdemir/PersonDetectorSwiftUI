//
//  ListViewItem.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 1.07.2025.
//

import SwiftUI

struct ListViewItem: View {
    let listModel : ListModel?
    private let  contextMenuAction : () -> Void
    private let onTapAction : () -> Void
    
    init(listModel: ListModel?, contextMenuAction: @escaping () -> Void, onTapAction: @escaping () -> Void) {
        self.listModel = listModel
        self.contextMenuAction = contextMenuAction
        self.onTapAction = onTapAction
    }
    
    var body: some View {
        VStack {
            Image(uiImage: getImage(with: listModel?.imageData))
                .resizable()
                .frame(width: 150, height: 210)
                .padding(.horizontal, 10)
                .padding(.top , 10)
          

            Text(listModel?.date.currentDateString() ?? "Unkown")
                .font(.system(size: 15, weight: .semibold))
        }
        .onTapGesture {
            onTapAction()
        }
        .contextMenu(menuItems: {
            Button {
               contextMenuAction()
            } label: {
                Text("Remove")
            }

        })
        .background(
            (listModel?.isPersonDetected ?? false ? Color.red.opacity(0.4) : Color.primary.opacity(0.1))
                .cornerRadius(10)
        )
        
       
    }
    
    func getImage(with data : Data?) -> UIImage {
        guard let data , let uiImage = UIImage(data: data) else {
            return UIImage(resource: .placeholder)
        }
        return uiImage
    }
}

extension ListViewItem {
    private func content(for model: ListModel) -> some View {
        VStack {
            Image(uiImage: getImage(with: model.imageData))
                .resizable()
                .frame(width: 150, height: 210)
                .padding(.horizontal, 10)
                .padding(.top , 10)
          

            Text(model.date.currentDateString())
                .font(.system(size: 15, weight: .semibold))
        }
        .onTapGesture {
            onTapAction()
        }
        .contextMenu(menuItems: {
            Button {
               contextMenuAction()
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


