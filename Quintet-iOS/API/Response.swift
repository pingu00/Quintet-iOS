//
//  QuintetResponse.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/20.
//

import Foundation

struct WeeklyDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: WeeklyResult
}
struct WeeklyResult : Codable{
    let user_id: String
    let startOfWeek: String
    let endOfWeek: String
    let weeklyData: [DailyData]
}

struct DailyData : Codable{
    let date: String
    let work_deg: Int
    let health_deg: Int
    let family_deg: Int
    let relationship_deg: Int
    let money_deg: Int
}

//MARK: - Statistics
struct StatisticsDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: StatisticsResult
}

struct StatisticsResult : Codable {
    let user_id : String
    let startDate : String?
    let endDate : String?
    let year : String?
    let month : String?
    let workPointPer : String
    let healthPointPer : String
    let familyPointPer : String
    let assetPointPer : String
    let relationshipPointPer : String
    let maxValue : [String]
    
    enum CodingKeys: String, CodingKey {
        case user_id,year,month
        case startDate = "start_date"
        case endDate = "end_date"
        case workPointPer = "work_per"
        case healthPointPer = "health_per"
        case familyPointPer = "family_per"
        case assetPointPer = "money_per"
        case relationshipPointPer = "relationship_per"
        case maxValue = "maxVals"
    }
}

struct RecordDataResponse : Codable {
    var isSuccess : Bool
    var code : Int
    var message : String
    var result : [RecordResult]
}
struct RecordResult : Codable {
    var id: Int
    var date: String
    var workDeg: Int?
    var workDoc: String?
    var healthDeg: Int?
    var healthDoc: String?
    var familyDeg: Int?
    var familyDoc: String?
    var relationshipDeg: Int?
    var relationshipDoc: String?
    var moneyDeg: Int?
    var moneyDoc: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, date
        case workDeg = "work_deg"
        case workDoc = "work_doc"
        case healthDeg = "health_deg"
        case healthDoc = "health_doc"
        case familyDeg = "family_deg"
        case familyDoc = "family_doc"
        case relationshipDeg = "relationship_deg"
        case relationshipDoc = "relationship_doc"
        case moneyDeg = "money_deg"
        case moneyDoc = "money_doc"
        case userId = "user_id"
    }
}






