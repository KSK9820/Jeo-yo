//
//  ClassifyModalView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/24/24.
//

import SwiftUI

struct ClassifyModalView: View {
    
    @ObservedObject private(set) var viewModel: ClassifyModalViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    
    init(_ viewModel: ClassifyModalViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            companyNameSection()
                .padding(.top)
            periodSection()
            stepSection()
                .padding(.bottom)
            Spacer()
            saveButton()
        }
        .frame(width: ContentSize.screenWidth - 16, height: ContentSize.screenHeight * 0.4)
        .background(.jeoyoMain)
        .cornerRadius(20)
        .ignoresSafeArea(edges: .all)
    }
    
    private func companyNameSection() -> some View {
        VStack {
            HStack(spacing: 20, content: {
                Text("회사명 |")
                    .font(.caption)
                    .bold()
                TextField("회사명을 입력해주세요.", text: $viewModel.recruitment.company)
                    .font(.caption)
            })
            .classifyInputStyle()
        }
    }
    
    private func periodSection() -> some View {
        HStack(content: {
            
            Text("기간    |")
                .font(.caption)
                .bold()
            Spacer()
            VStack {
                DatePickerTextView(date: $viewModel.recruitment.applicationPeriods.startDate, title: "시작")
                DatePickerTextView(date: $viewModel.recruitment.applicationPeriods.endDate, title: "종료")
            }
            Spacer()
        })
        .classifyInputStyle()
    }
    
    private func stepSection() -> some View {
        VStack {
            HStack {
                Text("전형별 상세 정보")
                    .font(.caption)
                    .bold()
                Spacer()
            }
            
            ForEach($viewModel.recruitment.steps, id: \.id) { $item in
                StepTextFieldView(step: $item) {
                    if let index = viewModel.recruitment.steps.firstIndex(where: { $0.id == item.id }) {
                        viewModel.recruitment.steps.remove(at: index)
                    }
                }
            }
            
            Button {
                viewModel.input.addStepButtonTapped.send(())
            } label: {
                Image(systemName: "plus.app")
                    .foregroundStyle(.black)
            }
            .classifyInputStyle()
        }
        .classifyInputStyle()
    }
    
    private func saveButton() -> some View {
        return Button {
            if viewModel.validatePeriod() {
                viewModel.input.saveButtonTapped.send(())
                presentationMode.wrappedValue.dismiss()
                coordinator.didTriggerAction = true
            } else {
                showAlert = true
            }
        } label: {
            HStack {
                Spacer()
                Text("저장하기")
                    .foregroundStyle(.black)
                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("날짜 오류"), message: Text("종료일이 시작일보다 이릅니다."))
        }
        .classifyInputStyle()
        .shadow(color: .black, radius: 1)
        .padding(.bottom, 66)
        
    }
}

struct StepTextFieldView: View {
    @Binding var step: Step
    var onDelete: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                TextField("전형 단계", text: $step.name)
                    .font(.caption2)
                    .bold()
                Button {
                    onDelete()
                } label: {
                    Text("삭제")
                        .foregroundStyle(.red)
                        .font(.caption2)
                }
                Spacer()
            }
            
            DatePickerTextView(date: $step.period.startDate, title: "시작")
            DatePickerTextView(date: $step.period.endDate, title: "종료")
            
            TextField("메모", text: $step.description)
                .padding(.bottom)
                .font(.caption2)
                .foregroundStyle(.gray)
                .padding(.leading)

            Divider()
        }
        .padding([.top, .horizontal])
    }
}

struct DatePickerTextView: View {
    
    @Binding var date: Date?
    @State private var showDatePicker = false
    
    var title: String
    
    var body: some View {
        VStack {
            Text(date?.toString(format: .yyyymmdd_HHmm) ?? title)
                .font(.caption2)
                .onTapGesture {
                    if !showDatePicker {
                        showDatePicker = true
                    }
                }
                .frame(width: ContentSize.screenWidth - 150, height: 30)
            
            if showDatePicker {
                DatePicker(
                    title,
                    selection: optionalBinding(for: $date, defaultValue: Date()),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: date ?? Date()) { newDate in
                    showDatePicker = false
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    ClassifyModalView(ClassifyModalViewModel(recruitment: Recruitment(id: UUID(), company: "", applicationPeriods: ApplicationPeriod(), steps: [], image: Data())))
}

