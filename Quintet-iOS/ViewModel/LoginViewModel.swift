//
//  LoginViewModel.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/09/02.
//
import SwiftUI
import GoogleSignIn
import Moya
import AuthenticationServices
import KakaoSDKUser

final class LoginViewModel: ObservableObject{

    @Published private(set) var hasKeychain: Bool
    
    private let loginManager = AuthManager.shared
    func updateHasKeychain(state: Bool) {
        hasKeychain = state
    }

    init() {
        let hasAccessToken =  KeyChainManager.hasKeychain(forkey: .accessToken)
        let isNonMember = KeyChainManager.read(forkey: .isNonMember) == "true"

        hasKeychain = hasAccessToken || isNonMember
    }
    
    enum Input {
        case logout
        case withdrawApple(code: String)
        case withdrawKakao
        case withdrawGoogle
    }
    
    func action(_ input: Input) {
        switch input {
        case .logout:
            logout()
        case .withdrawApple(let code):
            withdrawApple(code: code)
        case .withdrawKakao:
            withdrawKakao()
        case .withdrawGoogle:
            withdrawGoogle()
        }
    }
    
    private func logout() {
        loginManager.logout { [weak self] result in
            switch result {
            case .success(_):
                KeyChainManager.removeAllKeychain()
                self?.updateHasKeychain(state: false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - APPLE
extension LoginViewModel {
    func appleSignIn(_ credential: ASAuthorizationAppleIDCredential) {
        var fullName = credential.fullName
        var fullNameString: String?
        
        if let firstName = fullName?.givenName {
            if let lastName = fullName?.familyName {
                fullNameString = "\(firstName) \(lastName)"
            } else {
                fullNameString = "\(firstName)"
            }
        } else {
            if let lastName = fullName?.familyName {
                fullNameString = "\(lastName)"
            }
        }
        
        postAppleIdToken(
            idToken: credential.identityToken,
            name: fullNameString,
            email: credential.email
        )
    }

    func postAppleIdToken(
        idToken: Data?,
        name: String?,
        email: String?
    ) {
        let provider = MoyaProvider<OAuthAPI>()
        provider.request(.postAppleIdToken(token: idToken, name: name, email: email)) { result in
            switch result {
            case .success(let response):
                print("success")
                do {
                    if let header = response.response?.allHeaderFields as? [String: String],
                       let accessToken = header["Authorization"] {
                        KeyChainManager.save(forKey: .accessToken, value: accessToken)
                        KeyChainManager.save(forKey: .socialProvider, value: SocialProvider.APPLE.rawValue)
                        self.updateHasKeychain(state: true)
                    }

                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(OAuthResponse.self, from: response.data)

                    if tokenResponse.isSuccess {
                        
                        let jwtToken = tokenResponse.result
                    }else {
                        print(tokenResponse)
                        print("id 토큰이 유효하지 않음")
                    }
                } catch {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    private func withdrawApple(code: String) {
        loginManager.withdraw(.APPLE, code: code) { [weak self] result in
            switch result {
            case .success(let response):
                KeyChainManager.removeAllKeychain()
                self?.updateHasKeychain(state: false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - GOOGLE
extension LoginViewModel {
    
    private func getGoogleIDToken(completion: @escaping (String?) -> Void){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(nil)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController){ signInResult, err in
            if let error = err{
                print("Google SignIn 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let signInResult = signInResult else{
                completion(nil)
                return
            }
            
            signInResult.user.refreshTokensIfNeeded{ user, error in
                if let error = error{
                    print("Google SignIn 토큰 리프레시 error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let user = user else{
                    completion(nil)
                    return
                }
                
                let idToken = user.idToken?.tokenString
                completion(idToken)
            }
        }
    }

    // MARK: - getGoogleIDToken을 이용하여 얻은 idToken을 백엔드 서버에 전달
    private func postGoogleIdToken(idToken: String){
        let provider = MoyaProvider<OAuthAPI>()
        provider.request(.postGoogleIdToken(token: idToken)) { result in
            print(result)
            switch result{
            case .success(let response):
                do{
                    if let header = response.response?.allHeaderFields as? [String: String],
                       let accessToken = header["Authorization"] {
                        KeyChainManager.save(forKey: .accessToken, value: accessToken)
                        KeyChainManager.save(forKey: .socialProvider, value: SocialProvider.GOOGLE.rawValue)
                        self.updateHasKeychain(state: true)
                    }

                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(OAuthResponse.self, from: response.data)
                    print(tokenResponse)
                    if tokenResponse.isSuccess{
                        let jwtToken = tokenResponse
                    }else {
                        print("id 토큰이 유효하지 않음")
                    }
                } catch{
                    print("JSON 파싱 실패: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    func googleSignIn() {
        print("구글 로그인 시도 시작")
        getGoogleIDToken{ idToken in
            guard let idToken = idToken else {
                print("Google ID 토큰 얻기 실패")
                return
            }

            self.postGoogleIdToken(idToken: idToken)
        }
        
        print("구글 로그인 시도 마무리")
    }
    
    private func withdrawGoogle() {
        loginManager.withdraw(.GOOGLE) { [weak self] result in
            switch result {
            case .success(let response):
                GIDSignIn.sharedInstance.disconnect { error in
                    if let error = error {
                        // TODO: - 에러 처리
                    } else {
                        KeyChainManager.removeAllKeychain()
                        self?.updateHasKeychain(state: false)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - KAKAO
extension LoginViewModel {
    func kakaoSignIn() {
        UserApi.shared.loginWithKakaoAccount {ouathToken, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let idToken = ouathToken?.idToken
                else {
                    
                    print("카카오 idToken 존재하지 않음")
                    return
                }
                self.postKakaoIdToken(token: idToken)
            }
        }
    }
    
    private func postKakaoIdToken(token: String) {
        let provider = MoyaProvider<OAuthAPI>()
        provider.request(.postKakaoIdToken(token: token)) { result in
            print(result)
            switch result{
            case .success(let response):
                do{
                    if let header = response.response?.allHeaderFields as? [String: String],
                       let accessToken = header["Authorization"] {
                        KeyChainManager.save(forKey: .accessToken, value: accessToken)
                        KeyChainManager.save(forKey: .socialProvider, value: SocialProvider.KAKAO.rawValue)
                        self.updateHasKeychain(state: true)
                    }

                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(OAuthResponse.self, from: response.data)
                    print(tokenResponse)
                    if tokenResponse.isSuccess{
                        _ = tokenResponse
                    }else {
                        print("id 토큰이 유효하지 않음")
                    }
                } catch{
                    print("JSON 파싱 실패: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    private func withdrawKakao() {
        loginManager.withdraw(.GOOGLE) { [weak self] result in
            switch result {
            case .success(let response):
                print("%%%%%%%%%%%%")
                print(String(decoding: response.data, as: UTF8.self))
                UserApi.shared.unlink { [weak self] error in
                    if let error = error {
                        // TODO: - 에러 처리
                    } else {
                        KeyChainManager.removeAllKeychain()
                        self?.updateHasKeychain(state: false)
                    }
                }
                KeyChainManager.removeAllKeychain()
                self?.updateHasKeychain(state: false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
