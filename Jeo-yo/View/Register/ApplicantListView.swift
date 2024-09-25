//
//  ApplicantListView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/23/24.
//

import SwiftUI

struct ApplicantListView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isImageSelected: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: NavigationLazyView(RegisterView(selectedImage)), isActive: $isImageSelected) {
                    EmptyView()
                }
                .navigationTitle("지원 공고 목록")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    plusToolbarItem()
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private func plusToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            PhotoPickerView(selectedImage: $selectedImage)
                .onChange(of: selectedImage) { newItem in
                    guard let newItem else { return }
                    isImageSelected = true
                }
        }
    }
}

#Preview {
    ApplicantListView()
}

