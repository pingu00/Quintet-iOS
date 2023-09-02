//
//  API.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/20.
//

import Foundation
import Moya

enum OAuthAPI{
    case postGoogleIdToken(token: String)
}

extension OAuthAPI: TargetType{
    var baseURL: URL {
        return URL(string: "https://quintet.store")!
    }
    
    var path: String {
        switch self{
        case .postGoogleIdToken:
            return "/auth/google"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .postGoogleIdToken:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case.postGoogleIdToken(let token):
            return .requestParameters(parameters: ["token" : token], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
