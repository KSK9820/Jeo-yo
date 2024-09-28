//
//  PhotoPickerView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/23/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images, preferredItemEncoding: .automatic) {
            Image(systemName: "plus")
                .foregroundStyle(.gray)
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem[0].loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}

//#Preview {
//    PhotoPickerView()
//}
