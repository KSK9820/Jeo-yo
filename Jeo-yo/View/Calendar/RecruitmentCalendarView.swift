//
//  RecruitmentCalendarView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI

struct RecruitmentCalendarView: View {
    @ObservedObject private var viewModel = RecruitmentCalendarViewModel()
    @State private var month = Date()
    @State private var clickedDate = Date()
    
    
    var body: some View {
        CustomCalenderView(month: $month, recruitments: $viewModel.monthlyRecruitment, clickedDate: $clickedDate)
            .onChange(of: month) { newMonth in
                viewModel.input.selectedMonth.send(newMonth)
            }
            .onChange(of: clickedDate, perform: { selectedDate in
                viewModel.input.selectedDate.send(selectedDate)
            })
            .onAppear {
                viewModel.input.selectedMonth.send(month)
                viewModel.input.selectedDate.send(clickedDate)
            }
        
        List {
            ForEach(viewModel.selectedDateRecruitment, id: \.id) { item in
                ApplicantContentView(viewModel: ApplicantContentViewModel(item))
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
}

#Preview {
    RecruitmentCalendarView()
}
