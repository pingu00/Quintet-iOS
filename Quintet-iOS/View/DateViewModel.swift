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
    
    var yearButtonText: Text {
        Text("\(Utilities.formatNum(selectedYear))년")
    }
}
