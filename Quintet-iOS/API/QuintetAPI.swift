//
//  QuintetAPI.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/18.
//

import Foundation
import Moya

enum QuintetAPI {
    case getWeekCheck(user_id : Int)
    case postTodays (parameters: [String: Any])
    case patchTodays(Data)
    case getRecords(user_id : String, type : String , year : Int, month : Int)
    case getWeekStatic(user_id : String, startDate : String, endDate: String)
    case getMonthStatic(user_id : String, year: Int, month: Int)
    case getYearStatic(user_id : String, year: Int)
}

extension QuintetAPI : TargetType {
    var baseURL: URL {
        return URL(string: "http://52.79.148.241:3000")!
    }
    
    var path: String {
        switch self {
        case .getWeekCheck:
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
        case .getWeekCheck(let userID) :
            return .requestParameters(parameters: ["user_id": userID], encoding: URLEncoding.default)
        case .postTodays(let parameters) :
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .patchTodays(let data) :
            return .requestData(data)
        case .getRecords(let user_id, let type, let year, let month) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "type" : type, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getWeekStatic(let user_id, let startDate, let endDate) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "startDate" : startDate, "endDate" : endDate], encoding: URLEncoding.default)
        case .getMonthStatic(let user_id, let year, let month) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getYearStatic(let user_id, let year) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
