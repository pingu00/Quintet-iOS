//
//  Quintet_iOSApp.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

@main
struct Quintet_iOSApp: App{
    @State private var isLoading = true
    @StateObject private var loginViewModel = LoginViewModel()
    var loginManager = LoginManager()
    private var hasToken = KeyChainManager.hasKeychain(forkey: .accessToken)
    private var isNonMember = KeyChainManager.read(forkey: .isNonMember) == "true"
    
    var body: some Scene{
        WindowGroup{
            if isLoading{
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
                if loginViewModel.hasKeychain {
                    HomeView().environmentObject(loginViewModel)
                }
                else{
                    LoginView().environmentObject(loginViewModel)
                }
            }
        }
    }
}
