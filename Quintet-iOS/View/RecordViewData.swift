//
//  RecordViewData.swift
//  Quintet-iOS
//
//  Created by 옥재은 on 2023/07/30.
//

import Foundation

//날짜별 개별 기록 카드
struct Task: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var title: String
    var subtitle: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}


//날짜별 기록 -> 캘린더에 키록
var tasks: [TaskMetaData] = [

    TaskMetaData(task: [
        Task(icon : "CircleOn", title: "일", subtitle: "리서치 과제 제출 완료\n공부 2시간"),
        Task(icon: "CircleOn", title: "건강", subtitle: "런닝 30분 웨이트\n1시간"),
        Task(icon: "XOn", title: "가족", subtitle: ""),
        Task(icon: "TriangleOn", title: "관계", subtitle: "제형이와 함께 과제"),
        Task(icon: "TriangleOn", title: "자산", subtitle: "제테크 책 완독")
    ], taskDate:   getSampleDate(offset: -10)),
    
    TaskMetaData(task: [
        Task(icon : "CircleOn", title: "일", subtitle: "리서치 과제 제출 완료\n공부 2시간"),
        Task(icon: "CircleOn", title: "건강", subtitle: "런닝 30분 웨이트\n1시간"),
        Task(icon: "XOn", title: "가족", subtitle: ""),
        Task(icon: "TriangleOn", title: "관계", subtitle: "제형이와 함께 과제"),
        Task(icon: "TriangleOn", title: "자산", subtitle: "제테크 책 완독")
    ], taskDate:   getSampleDate(offset: -18)),
    
    TaskMetaData(task: [
        Task(icon : "CircleOn", title: "일", subtitle: "리서치 과제 제출 완료\n공부 2시간"),
        Task(icon: "CircleOn", title: "건강", subtitle: "런닝 30분 웨이트\n1시간"),
        Task(icon: "XOn", title: "가족", subtitle: ""),
        Task(icon: "TriangleOn", title: "관계", subtitle: "제형이와 함께 과제"),
        Task(icon: "TriangleOn", title: "자산", subtitle: "제테크 책 완독")
    ], taskDate:   getSampleDate(offset: -25))
    
]

