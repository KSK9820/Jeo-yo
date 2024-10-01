//
//  ApplicantListView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/23/24.
//

import SwiftUI
import AlertToast

struct ApplicantListView: View {
    
    @StateObject private var viewModel = ApplicantListViewModel()
    @StateObject var coordinator = NavigationCoordinator()
    @State private var selectedImage: UIImage? = nil
    @State private var isImageSelected: Bool = false
    @State private var searchText = ""
    @State private var isError = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: NavigationLazyView(RegisterView(selectedImage, isError: $isError).environmentObject(coordinator)), isActive: $isImageSelected) {
                    Text("")
                }
                .navigationTitle("지원 공고 목록")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    plusToolbarItem()
                }
            
                if viewModel.searchRecruitment.isEmpty {
                    Text("저장한 공고가 없습니다. \n이미지로 공고를 편하게 등록해보세요!")
                        .frame(alignment: .center)
                } else {
                    List() {
                        ForEach($viewModel.searchRecruitment, id: \.id) { $item in
                            let viewModel = ApplicantContentViewModel($item.wrappedValue)
                            ApplicantContentView(viewModel: viewModel)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .toast(isPresenting: $isError, alert: {
                AlertToast(type: .error(.red), subTitle: "채용 공고 이미지를 등록해주세요 :)")
            })
            .searchable(text: $searchText, prompt: "회사명을 검색해보세요 🙋🏻")
            .detectSearchableTextDeleted(searchText: $searchText, onClear: {
                viewModel.input.resetText.send(())
            })
            .onSubmit(of: .search) {
                viewModel.input.searchText.send(searchText)
            }
            .onReceive(coordinator.$didTriggerAction, perform: { didTrigger in
                if didTrigger {
                    viewModel.input.updateData.send(())
                }
            })
            .onAppear {
                viewModel.input.updateData.send(())
            }
        }
    }
    
    @ToolbarContentBuilder
    private func plusToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            PhotoPickerView(selectedImage: $selectedImage)
                .onChange(of: selectedImage) { newItem in
                    guard let _ = newItem else { return }
                    isImageSelected = true
                }
        }
    }
}


#Preview {
    ApplicantListView()
}

