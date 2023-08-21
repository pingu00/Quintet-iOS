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

