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

struct DailyData : Codable{
    let date: String
    let work_deg: Int
    let health_deg: Int
    let family_deg: Int
    let relationship_deg: Int
    let money_deg: Int
}

struct WeeklyResult : Codable{
    let user_id: String
    let startOfWeek: String
    let endOfWeek: String
    let weeklyData: [DailyData]
}

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
