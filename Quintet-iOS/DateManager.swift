//
//  DateManager.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/07/29.
//

import SwiftUI

// MARK: - 날짜에 관련된 다양한 기능을 수행하는 구조체 **날짜 data를 어떻게 받느냐에 따라 수정 필요**
struct DateManager{
    let today = Date()
    
    //"M월 d일 E요일" 형식으로 오늘의 날짜를 반환해줌
    func getTodayText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        return dateFormatter.string(from: today)
    }
    
    //날짜 string을 기반으로 해당 날짜가 오늘인지 판단하는 함수
    func is_today(dateStr: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        let todayStr = dateFormatter.string(from: today)
        
        return dateStr == todayStr
    }
    
    //날짜 string을 기반으로 그날의 일자를 string으로 반환해주는 함수
    func get_day(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateStr) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
            return dayFormatter.string(from: date)
        } else {return "Invalid Date"}
    }
    
    //날짜 string을 기반으로 그날의 요일을 string으로 반환해주는 함수
    func get_week(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateStr) {
            let weekFormatter = DateFormatter()
            weekFormatter.locale = Locale(identifier: "ko_KR")
            weekFormatter.dateFormat = "EEE"
            return weekFormatter.string(from: date)
        } else {return "Invalid Date"}
    }
}
