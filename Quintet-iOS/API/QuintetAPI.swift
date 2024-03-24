//
//  QuintetAPI.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/18.
//

import Foundation
import Moya

enum QuintetAPI {
    case postAllData (data: [RecordResult])
    case postTodays (parameters: [String: Any])
    case getWeekCheck(user_id : Int)
    case getWeekStatic(user_id : String, startDate : String, endDate: String)
    case getMonthStatic(user_id : String, year: Int, month: Int)
    case getYearStatic(user_id : String, year: Int)
    case getRecordsByDate(user_id : String, year : Int, month : Int)
    case getRecordsByElement(user_id : String, year : Int, month : Int, element : String)
    case getProfileName
    case patchProfileName(newNickname : String)
}

extension QuintetAPI : TargetType {
    var baseURL: URL {
        guard let path = Bundle.main.path(forResource: "secret", ofType: "plist") else {
            fatalError("secret.plist 파일을 찾을 수 없습니다.")
        }
        guard let data = FileManager.default.contents(atPath: path) else {
            fatalError("secret.plist 파일을 읽어올 수 없습니다.")
        }
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            fatalError("secret.plist를 NSDictionary로 변환할 수 없습니다.")
        }

        if let baseURLString = plistDictionary["BaseURL"] as? String,
           let url = URL(string: baseURLString) {
            return url
        } else {
            fatalError("BaseURL을 찾을 수 없거나 유효하지 않습니다.")
        }
    }

    
    var path: String {
        switch self {
        case .postAllData:
            return "/user/data"
        case .postTodays:
            return "/record"
        case .getWeekCheck:
            return "/home"
        case .getWeekStatic:
            return "/static/week"
        case .getMonthStatic:
            return "/static/month"
        case .getYearStatic:
            return "/static/year"
        case .getRecordsByDate:
            return "/records/date"
        case .getRecordsByElement:
            return "/records/element"
        case .getProfileName, .patchProfileName:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeekCheck,.getWeekStatic, .getMonthStatic, .getYearStatic, .getRecordsByDate, .getRecordsByElement, .getProfileName:
            return .get
        case .postTodays, .postAllData:
            return .post
        case .patchProfileName:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .postAllData(let data) :
            return .requestParameters(parameters: ["data": data], encoding: JSONEncoding.default)
        case .postTodays(let parameters) :
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getWeekCheck(let userID) :
            return .requestParameters(parameters: ["user_id": userID], encoding: URLEncoding.default)
        case .getWeekStatic(let user_id, let startDate, let endDate) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "startDate" : startDate, "endDate" : endDate], encoding: URLEncoding.default)
        case .getMonthStatic(let user_id, let year, let month) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getYearStatic(let user_id, let year) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year], encoding: URLEncoding.default)
        case .getRecordsByDate(let user_id, let year, let month) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year, "month" : month], encoding: URLEncoding.default)
        case .getRecordsByElement(let user_id, let year, let month, let element) :
            return .requestParameters(parameters:
                                        ["user_id" : user_id, "year" : year, "month" : month, "element" : element], encoding: URLEncoding.default)
        case .getProfileName:
            return .requestPlain
        
        case .patchProfileName(let newNickname) :
            return .requestParameters(parameters:
                                        ["newNickname" : newNickname], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        let token = KeyChainManager.read(forkey: .accessToken)
                return ["Authorization": "Bearer \(token)", "Content-type": "application/json"]
    }
}
