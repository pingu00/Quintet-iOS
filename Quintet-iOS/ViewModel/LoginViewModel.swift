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


final class LoginViewModel: ObservableObject{

    @Published private(set) var hasKeychain: Bool
    private let loginManager = LoginManager.shared
    
    func updateHasKeychain(state: Bool) {
        hasKeychain = state
    }
    
    init() {
        let hasAccessToken =  KeyChainManager.hasKeychain(forkey: .accessToken)
        let isNonMember = KeyChainManager.read(forkey: .isNonMember) == "true"
        
        hasKeychain = hasAccessToken || isNonMember
    }
}

// MARK: - apple login
extension LoginViewModel {
    func getToken(_ appleCredential: ASAuthorizationAppleIDCredential) {
        var fullName = appleCredential.fullName
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
        
        let result = loginManager.postAppleIdToken(
            idToken: appleCredential.identityToken,
            name: fullNameString,
            email: appleCredential.email
        )
        
        print("Apple Login 결과: ", result)
    }
}

// MARK: - google login
extension LoginViewModel {
    
    func postGoogleIDToken(completion: @escaping (String?) -> Void){
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
    
    func googleSignIn() {
        print("구글 로그인 시도 시작")
        postGoogleIDToken{ idToken in
            guard let idToken = idToken else {
                print("Google ID 토큰 얻기 실패")
                return
            }
            
            let result = self.loginManager.postGoogleIdToken(idToken: idToken)
            
            print("google 로그인 결과: ", result)
        }
        
        // MARK: - 서버 연결 없이 HomeView로 이동하고 싶으면 아래 주석을 해제
//        print("서버 닫힌 상태에서 테스트")
//        isLoggedIn = true
//        UserDefaults.standard.set(1, forKey: "LoginID")
        
        print("구글 로그인 시도 마무리")
    }
}

extension LoginViewModel {
    
}
