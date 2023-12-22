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
    case postAppleIdToken(
        token: Data?,
        name: String?,
        email: String?
    )
}

extension OAuthAPI: TargetType{
    var baseURL: URL {
        return URL(string: "https://quintet.store")!
    }
    
    var path: String {
        switch self{
        case .postGoogleIdToken:
            return "/auth/google"
        case .postAppleIdToken:
            return "/auth/apple"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .postGoogleIdToken:
            return .post
        case .postAppleIdToken:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case.postGoogleIdToken(let token):
            return .requestParameters(parameters: ["token" : token], encoding: JSONEncoding.default)
            
        case.postAppleIdToken(
            let token,
            let name,
            let email
        ):
            var parameters: [String: Any] = [:]
            if 
                let token = token,
                let tokenString = String(data: token, encoding: .utf8)
            {
                parameters.updateValue(tokenString, forKey: "idToken")
            }
            if let name = name {
                parameters.updateValue(name, forKey: "name")
            }
            if let email = email {
                parameters.updateValue(email, forKey: "email")
            }
            
            return .requestParameters(
                parameters: parameters, encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
