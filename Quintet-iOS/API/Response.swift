//
//  QuintetResponse.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/20.
//

import Foundation

struct ProfileDataResponse : Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ProfileResult
}
struct ProfileResult : Codable{
    let id: Int?
    let nickname: String
    let email: String?
    let provider: String?
}


//MARK: -Weeklydata
struct WeeklyDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: WeeklyResult
}
struct WeeklyResult : Codable{
    let user_id: Int
    let startOfWeek: String
    let endOfWeek: String
    let weeklyData: [DailyData]
}

struct DailyData : Codable{
    let date: String
    let work_deg: String
    let health_deg: String
    let family_deg: String
    let relationship_deg: String
    let money_deg: String
}

//MARK: - Statistics
struct StatisticsDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: StatisticsResult
}

struct StatisticsResult: Codable {
    let userID: Int
    let year: String = ""
    let month: String = ""
    let startDate = ""
    let endDate = ""
    let workPer, healthPer: String
    let familyPer, relationshipPer, moneyPer: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case year
        case month
        case startDate = "start_date"
        case endDate = "end_date"
        case workPer = "work_per"
        case healthPer = "health_per"
        case familyPer = "family_per"
        case relationshipPer = "relationship_per"
        case moneyPer = "money_per"
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
    var work_deg: Int?
    var work_doc: String?
    var health_deg: Int?
    var health_doc: String?
    var family_deg: Int?
    var family_doc: String?
    var relationship_deg: Int?
    var relationship_doc: String?
    var money_deg: Int?
    var money_doc: String?
}






