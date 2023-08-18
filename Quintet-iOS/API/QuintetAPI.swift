//
//  QuintetAPI.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/18.
//

import Foundation
import Moya

enum QuintetAPI {
    case getWeekCheck(email : String, date : String)
    case postTodays(Data)
    case patchTodays(Data)
    case getRecords(email : String, type : String , year : Int, month : Int)
    case getWeekStatic(email : String, startDate : Date, endDate: Date)
    case getMonthStatic(email : String, year: Int, month: Int)
    case getYearStatic(email : String, year: Int)
}

extension QuintetAPI : TargetType {
    var baseURL: URL {
        return URL(string: "52.78.123.107:3000")!
    }
    
    var path: String {
        switch self {
        case .getWeekCheck :
            return "/home"
        case .postTodays, .patchTodays:
            return "/record"
        case .getRecords:
            return "/records"
        case .getWeekStatic:
            return "/static/week"
        case .getMonthStatic:
            return "/static/month"
        case .getYearStatic:
            return "/static/year"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeekCheck,.getRecords,.getWeekStatic, .getMonthStatic, .getYearStatic :
            return .get
        case .postTodays:
            return .post
        case .patchTodays:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getWeekCheck(let email, let date) :
            return .requestPlain
        case .postTodays(let data) :
            return .requestData(data)
        case .patchTodays(let data) :
            return .requestData(data)
        case .getRecords(let email, let type, let year, let month) :
            return .requestParameters(parameters:
                                        ["email" : email, "type" : type, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getWeekStatic(let email, let startDate, let endDate) :
            return .requestParameters(parameters:
                                        ["email" : email, "startDate" : startDate, "endDate" : endDate], encoding: URLEncoding.default)
        case .getMonthStatic(let email, let year, let month) :
            return .requestParameters(parameters:
                                        ["email" : email, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getYearStatic(let email, let year) :
            return .requestParameters(parameters:
                                        ["email" : email, "year" : year], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
