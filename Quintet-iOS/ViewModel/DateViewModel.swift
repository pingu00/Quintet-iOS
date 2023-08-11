//
//  DateViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/27.
//

import SwiftUI

class DateViewModel: ObservableObject {
    @Published var selectedYear = Calendar.current.component(.year, from: Date()){
        didSet {
            updateStartOfWeek()
        }
    }
    @Published var selectedMonth = Calendar.current.component(.month, from: Date()){
        didSet {
            updateStartOfWeek()
        }
    }
    
    @Published var startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    
    var selectedMonthFirstDay: Date {
        Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
    
    var selectedYearFirstDay: Date {
        Calendar.current.date(from: DateComponents(year: selectedYear, month: 1, day: 1))!
    }

    var weekButtonText: Text {
        let formattedStartDate = Utilities.formatYearMonthDay(startOfWeek)
        let formattedEndDate = Utilities.formatYearMonthDay(Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!)
        
        return Text("\(formattedStartDate) - \(formattedEndDate)")
    }

    private func updateStartOfWeek() {
        let calendar = Calendar.current
        startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedMonthFirstDay))!
    }
        
    var yearMonthButtonText: Text {
        Text("\(Utilities.formatNum(selectedYear))년 \(selectedMonth)월")
    }
    
    var yearMonthButtonTextRecordVer: Text {
        Text("\(Utilities.formatNum(selectedYear))년 \(selectedMonth)월")
            .fontWeight(.medium)
            .font(.system(size: 23))
    }
    
    var yearButtonText: Text {
        Text("\(Utilities.formatNum(selectedYear))년")
    }
    
    func updateCalendar() {
        let calendar = Calendar.current
        // 선택한 연도와 월을 기반으로 날짜를 계산
        guard calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) != nil else {
            return
        }
    }

    func getDatesForSelectedMonth() -> [DateValue] {
        let calendar = Calendar.current

        // 선택한 연도와 월을 기반으로 날짜를 계산
        guard let startDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) else {
            return []
        }

        let range = calendar.range(of: .day, in: .month, for: startDate)!
        var days = range.compactMap { day -> DateValue in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            let day = calendar.component(.day, from: date)

            return DateValue(day: day, date: date)
        }

        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday-1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }

        return days
    }
}

