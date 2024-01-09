//
//  LoginManager.swift
//  Quintet-iOS
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import Moya

struct LoginManager {
    static let shared = LoginManager()
    private let provider = MoyaProvider<OAuthAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private init() {}
    
    func updateAccessToken() -> Bool {
        var isUpdated = false
        provider.request(.updateAccessToken) { result in
            switch result {
            case .success(let response):
                let tokenResponse = getTokenResponse(response: response)
                guard
                    let tokenResponse = tokenResponse,
                    let refreshToken = tokenResponse.result
                else { return }
                KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
                isUpdated = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return isUpdated
    }
    
    func postGoogleIdToken(idToken: String) -> Bool {
        var isSuccess = false
        provider.request(.postGoogleIdToken(token: idToken)) { result in
            switch result {
            case .success(let response):
                let tokenResponse = getTokenResponse(response: response)
                guard
                    let tokenResponse = tokenResponse,
                    let refreshToken = tokenResponse.result
                else { return }
                KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
                isSuccess = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return isSuccess
    }
    
    func postAppleIdToken(
        idToken: Data?,
        name: String?,
        email: String?
    ) -> Bool {
        var isSuccess = false
        provider.request(.postAppleIdToken(token: idToken, name: name, email: email)) { result in
            switch result {
            case .success(let response):
                let tokenResponse = getTokenResponse(response: response)
                guard
                    let tokenResponse = tokenResponse,
                    let refreshToken = tokenResponse.result
                else { return }
                KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
                isSuccess = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return isSuccess
    }
    
    func postKakaoIdToken(idToken: String) -> Bool {
        var isSuccess = false
        provider.request(.postKakaoIdToken(token: idToken)) { result in
            switch result {
            case .success(let response):
                let tokenResponse = getTokenResponse(response: response)
                guard
                    let tokenResponse = tokenResponse,
                    let refreshToken = tokenResponse.result
                else { return }
                KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
                isSuccess = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return isSuccess
    }
    
    private func getTokenResponse(response: Response) -> TokenResponse? {
        let decoder = JSONDecoder()
        
        if let header = response.response?.allHeaderFields as? [String: String],
           let accessToken = header["Authorization"] 
        {
            KeyChainManager.save(forKey: .accessToken, value: accessToken)
        } else { return nil }
        
        do {
            let tokenResponse = try decoder.decode(TokenResponse.self, from: response.data)
            return tokenResponse
        } catch{
            print("JSON 파싱 실패: \(error.localizedDescription)")
        }
        return nil
    }
}
