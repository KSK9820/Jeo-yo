//
//  RegisterView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import SwiftUI
import Combine
import AlertToast

struct RegisterView: View {

    @EnvironmentObject var coordinator: NavigationCoordinator
    @Environment(\.presentationMode) var presentationMode
    @Binding var isError: Bool
    @StateObject private var viewModel = RegisterViewModel()
    @State private var currentScale: CGFloat = 1.0
    @State private var showSheet = false
    @State private var cancellables = Set<AnyCancellable>()
    
    let jobRecruitmentImage: UIImage?
    
    init(_ jobRecruitmentImage: UIImage?, isError: Binding<Bool>) {
        self.jobRecruitmentImage = jobRecruitmentImage
        self._isError = isError
    }
    
    
    var body: some View {
        ZStack {
            scrollableImage()
                .toast(isPresenting: $viewModel.showAlert) {
                    AlertToast(type: .loading, subTitle: "공고 분석 중입니다.\n ٩( ᐛ )و")
                }
                .task {
                    viewModel.input.readImage.send(jobRecruitmentImage?.pngData())
                }
                .onReceive(viewModel.errorPublisher) { error in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isError = true
                        presentationMode.wrappedValue.dismiss()
                        coordinator.didTriggerAction = true
                    }
                    
                }
            if let recruitment = viewModel.recrutiment {
                if !viewModel.showAlert {
                    VStack {
                        Spacer()
                        let vm = ClassifyModalViewModel(recruitment: recruitment)
                        ClassifyModalView(vm)
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
    RegisterView(UIImage(systemName: "star"), isError: .constant(false))
}
