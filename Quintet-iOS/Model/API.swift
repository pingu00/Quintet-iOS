//
//  API.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/20.
//

import Foundation
import Moya

enum LoginAPI{
    case getLoginURL
    case getCallBack
}

extension LoginAPI: TargetType{
    var baseURL: URL {
        return URL(string: "52.79.148.241:3000")!
    }
    
    var path: String {
        switch self{
        case .getLoginURL:
            return "/auth/google"
        case .getCallBack:
            return "/auth/google/callback"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getLoginURL:
            return .get
        case .getCallBack:
            return .get
        }
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "applicaion/json"]
    }
    
    
}
