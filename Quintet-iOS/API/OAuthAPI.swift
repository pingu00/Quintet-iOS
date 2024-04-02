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
    case postKakaoIdToken(token: String)
    case updateAccessToken
    case logout
    case withdraw(social: SocialProvider, code: String?)
}

extension OAuthAPI: TargetType{

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
        switch self{
        case .postGoogleIdToken:
            return "/auth/google"
        case .postAppleIdToken:
            return "/auth/apple"
        case .postKakaoIdToken:
            return "/auth/kakao"
        case .updateAccessToken:
            return "/auth/refresh"
        case .logout:
            return "/user/logout"
        case .withdraw:
            return "/user/delete"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .postKakaoIdToken, .postAppleIdToken, .postGoogleIdToken, .updateAccessToken, .withdraw:
            return .post
        case .logout:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .postGoogleIdToken(let token), .postKakaoIdToken(token: let token):
            return .requestParameters(parameters: ["idToken" : token], encoding: JSONEncoding.default)
            
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
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateAccessToken:
            var parameter: [String: Any] = [:]
            parameter.updateValue(KeyChainManager.loadRefreshToken(), forKey: "refreshToken")
            return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        case .withdraw(let social, let code):
            var parameter: [String: Any]
            if let code = code {
                parameter = [
                    "provider": "apple",
                    "code": code
                ]
            } else {
                parameter = [
                    "provider": "nonApple"
                ]
            }
            
            print(parameter)
            return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {

        switch self {
        case .postGoogleIdToken, .postAppleIdToken, .postKakaoIdToken:
            return [HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json]
        case .updateAccessToken, .logout, .withdraw:
            return [HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json,
                    HTTPHeaderFieldsKey.authorization: HTTPHeaderFieldsValue.accessToken
            ]
        }
    }
}
