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
    private let hasKeychain = KeyChainManager.hasKeychain(forkey: .accessToken)
    
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
                if hasKeychain {
                    HomeView()
                }
                else{
                    LoginView()
                }
            }
        }
    }
}
