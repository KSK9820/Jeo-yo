//
//  ApplicantListView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/23/24.
//

import SwiftUI

struct ApplicantListView: View {
    
    @StateObject private var viewModel = ApplicantListViewModel()
    
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
                
                List {
                    if let recruitmentList = viewModel.recruitment {
                        ForEach(recruitmentList, id: \.id) { item in
                            Text(item.company)
                        }
                    } else {
                        Text("저장한 공고가 없습니다. \n 이미지로 공고를 편하게 등록해보세요!")
                    }
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

