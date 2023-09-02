//
//  DateProcessingModel.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/10.
//

import Foundation

class DateProcessingModel{
    func convertDateToDayString(date: Date) -> String{
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return String(day)
    }
    
    func convertDateToWeekDayString(date: Date) -> String{
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
    
    func formatTodayToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        let formattedDate = dateFormatter.string(from: Date())
        return formattedDate
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
            components1.month == components2.month &&
            components1.day == components2.day
    }
}
