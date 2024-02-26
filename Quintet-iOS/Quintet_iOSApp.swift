//
//  Quintet_iOSApp.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct Quintet_iOSApp: App{
    @State private var isLoading = true
    @StateObject private var loginViewModel = LoginViewModel()
    
    private var hasToken = KeyChainManager.hasKeychain(forkey: .accessToken)
    private var isNonMember = KeyChainManager.read(forkey: .isNonMember) == "true"
    
    init() {
        guard 
            let path = Bundle.main.path(forResource: "secret", ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
            let kakaoKey = plistDictionary["KakaoKey"] as? String
        else { return }

        KakaoSDK.initSDK(appKey: kakaoKey)
    }
    
    var body: some Scene{
        WindowGroup{
            if isLoading {
                Image("QuintetLogo")
                    .transition(.opacity)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            withAnimation{
                                isLoading.toggle()
                            }
                        })
                    }
            }
            else{
                if hasToken || isNonMember {
                    HomeView().environmentObject(loginViewModel)
                }
                else{
                    LoginView()
                        .onOpenURL(perform: { url in
                            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                                AuthController.handleOpenUrl(url: url)
                            }
                        })
                        .environmentObject(loginViewModel)
                }
            }
        }
    }
}
