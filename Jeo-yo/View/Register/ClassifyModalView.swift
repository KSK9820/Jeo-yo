//
//  ClassifyModalView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/24/24.
//

import SwiftUI

struct ClassifyModalView: View {
    
    @ObservedObject private(set) var viewModel: ClassifyModalViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
        HStack(spacing: 20, content: {
            Text("기간    |")
                .font(.caption)
                .bold()
            VStack {
                TextFieldOrDatePickerView(date: $viewModel.recruitment.applicationPeriods.startDate, title: "시작")
                TextFieldOrDatePickerView(date: $viewModel.recruitment.applicationPeriods.endDate, title: "종료")
            }
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
        Button {
            viewModel.input.saveButtonTapped.send(())
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Spacer()
                Text("저장하기")
                    .foregroundStyle(.black)
                Spacer()
            }
        }
        .classifyInputStyle()
        .shadow(color: .black, radius: 1)
        .padding(.bottom)
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
            
            TextFieldOrDatePickerView(date: $step.period.startDate, title: "시작")
            TextFieldOrDatePickerView(date: $step.period.endDate, title: "종료")

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

struct TextFieldOrDatePickerView: View {
    
    @Binding var date: Date?
    @State private var showDatePicker = false
    @State var textFieldDate = ""
        
    var title: String
    
    var body: some View {
        VStack {
            TextField(title, text: $textFieldDate)
                .onTapGesture {
                    showDatePicker.toggle()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.caption2)
            
            
            if showDatePicker {
                DatePicker(
                    title,
                    selection: optionalBinding(for: $date, defaultValue: Date()),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: date ?? Date()) { newDate in
                    textFieldDate = newDate.toString(format: .yyyymmdd_HHmm)
                    showDatePicker = false
                }
            }
        }
        .onAppear {
            if let date {
                textFieldDate = date.toString(format: .yyyymmdd_HHmm)
            }
        }
    }
}




#Preview {
    ClassifyModalView(ClassifyModalViewModel(recruitment: Recruitment(id: UUID(), company: "", applicationPeriods: ApplicationPeriod(), steps: [], image: Data())))
}

