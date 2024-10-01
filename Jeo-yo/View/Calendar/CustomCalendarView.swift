//
//  CustomCalendarView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI

struct CustomCalenderView: View {
    @Binding var month: Date
    @Binding var recruitments: [Recruitment]
    @Binding var clickedDate: Date
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            headerView
            calendarGridView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
                .shadow(radius: 4)
        )
        .padding()
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        if let m = changeMonth(by: 1) {
                            month = m
                        }
                    } else if gesture.translation.width > 100 {
                        if let m = changeMonth(by: -1) {
                            month = m
                        }
                    }
                    self.offset = CGSize()
                }
        )
        Spacer()
    }
    
    private var headerView: some View {
        VStack {
            Text(month.toString(format: .yyyyMM_kr))
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical)
            
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .bold()
                }
            }
            .padding(.vertical, 4)
            .background(.jeoyoMain)
            .clipShape(.rect(cornerRadius: 15))
        }
        
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        
                        let filteredData = recruitments.filter { recruitment in
                            guard let startDate = recruitment.applicationPeriods.startDate,
                                  let endDate = recruitment.applicationPeriods.endDate
                            else { return false }
                            
                            return startDate <= date && date <= endDate
                        }
                        CellView(day: day, clicked: date.toString(format: .yyyyMMdd) == clickedDate.toString(format: .yyyyMMdd), companyName: filteredData)
                            .onTapGesture {
                                clickedDate = date
                            }
                    }
                }
            }
            
        }
    }
}

private struct CellView: View {
    var day: Int
    var clicked: Bool = false
    var recruitment: [Recruitment]
    
    init(day: Int, clicked: Bool, companyName: [Recruitment]) {
        self.day = day
        self.clicked = clicked
        self.recruitment = companyName
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .opacity(0)
                .overlay {
                    Text(String(day))
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 4)
            
            if !recruitment.isEmpty {
                Text(String(recruitment.count))
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .background(.red)
            } else {
                Spacer()
            }
        }
        .padding(.bottom)
        .border(clicked ? .deepSkyBlue : .clear, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

private extension CustomCalenderView {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) -> Date? {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
            return newMonth
        }
        return nil
    }
}


#Preview {
    let date = Date()
    let data = [
        Recruitment(id: UUID(), company: "a", applicationPeriods: ApplicationPeriod(startDate: Date().addingTimeInterval(-1000000), endDate: Date().addingTimeInterval(20000)), steps: [], image: Data()),
        Recruitment(id: UUID(), company: "b", applicationPeriods: ApplicationPeriod(startDate: Date().addingTimeInterval(-1000000), endDate: Date().addingTimeInterval(1000000)), steps: [], image: Data())
    ]
    return CustomCalenderView(month: .constant(date), recruitments: .constant(data), clickedDate: .constant(Date()))
}
