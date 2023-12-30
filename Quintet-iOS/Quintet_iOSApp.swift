//
//  Quintet_iOSApp.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

@main
struct Quintet_iOSApp: App{
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var isLoading = true
    
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
                if loginViewModel.isLoggedIn{
                    HomeView()
                }
                else{
                    LoginView()
                        .environmentObject(loginViewModel)
                }
            }
        }
    }
}
