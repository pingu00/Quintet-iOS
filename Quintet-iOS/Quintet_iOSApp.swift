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
                if UserDefaults.standard.string(forKey: "LoginID") != nil || loginViewModel.isLoggedIn{
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

//@main
//struct Quintet_iOSApp: App {
//    var body: some Scene {
//        WindowGroup {
//            LoginView()
//                .onAppear {
//                    NetworkManager.shared.fetchWeekCheckData(userID : 2)
//                    NetworkManager.shared.fetchWeekStatistics(userID : "2", startDate: "2023-08-13", endDate: "2023-08-19")
//                    NetworkManager.shared.fetchMonthStatistics(userID : "2", year: 2023, month: 8)
//                    NetworkManager.shared.fetchYearStatistics(userID : "2", year: 2023)
//                }
//        }
//    }
//}
