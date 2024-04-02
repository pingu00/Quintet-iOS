//
//  LoginManager.swift
//  Quintet-iOS
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import Moya

struct AuthManager {
    static let shared = AuthManager()
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
    
    private func getTokenResponse(response: Response) -> OAuthResponse? {
        let decoder = JSONDecoder()
        
        if let header = response.response?.allHeaderFields as? [String: String],
           let accessToken = header["Authorization"]
        {
            KeyChainManager.save(forKey: .accessToken, value: accessToken)
        } else { return nil }
        
        do {
            let tokenResponse = try decoder.decode(OAuthResponse.self, from: response.data)
            return tokenResponse
        } catch{
            print("JSON 파싱 실패: \(error.localizedDescription)")
        }
        return nil
    }
    
    func logout(completion: @escaping (Result<Bool, MoyaError>) -> Void) {
        provider.request(.logout) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func withdraw(
        _ social: SocialProvider,
        code: String? = nil,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(.withdraw(social: social, code: code)) { result in
            print(result)
            switch result {
            case .success(let success):
                print(success.statusCode)
                completion(.success(success))
            case .failure(let error):
                print(String(decoding: error.response!.data, as: UTF8.self))
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
