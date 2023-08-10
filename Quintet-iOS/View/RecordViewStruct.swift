//
//  RecordViewStruct.swift
//  Quintet-iOS
//
//  Created by 옥재은 on 2023/08/10.
//

import Foundation

//날짜와 요일 저장
struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

//기록 개별 카드
struct Record: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var title: String
    var subtitle: String
}

struct CalendarMetaData: Identifiable {
    var id = UUID().uuidString
    var records: [Record]
    var date: Date
    var offset: Int
}

struct RecordMetaData: Identifiable {
    var id = UUID().uuidString
    var records : [Record]
}

