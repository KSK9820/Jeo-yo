//
//  RegisterView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import SwiftUI
import AlertToast

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    @State private var currentScale: CGFloat = 1.0
    @State private var showSheet = false
    
    let jobRecruitmentImage: UIImage?
    
    init(_ jobRecruitmentImage: UIImage?) {
        self.jobRecruitmentImage = jobRecruitmentImage
    }
    
    
    var body: some View {
        ZStack {
            scrollableImage()
                .toast(isPresenting: $viewModel.showAlert) {
                    AlertToast(type: .loading, subTitle: "공고 분석 중\n 아자아자!")
                }
                .task {
                    viewModel.input.readImage.send(jobRecruitmentImage?.pngData())
                }
                .toolbar {
                    ToolbarItem {
                        Text("저장")
                            .font(.callout)
                            .onTapGesture {
                                // 저장
                            }
                    }
                }
            if let recruitment = viewModel.recrutiment {
                if !viewModel.showAlert {
                    VStack {
                        Spacer()
                        ClassifyModalView(ClassifyModalViewModel(recruitment: recruitment))
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: !viewModel.showAlert)
                    }
                    .allowsHitTesting(true)
                }
            }
        }
        .padding(.bottom)
    }

    private func scrollableImage() -> some View {
        GeometryReader { geometry in
            ZoomableScrollView(
                Image(uiImage: jobRecruitmentImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .padding(.bottom, ContentSize.screenHeight * 0.5),
                currentScale: $currentScale
            )
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    RegisterView(UIImage(systemName: "star"))
}