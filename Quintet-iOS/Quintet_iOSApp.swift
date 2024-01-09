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
                        .onAppear {
                            NetworkManager.shared.postCheckData(parameters: ["user_id" : 1, "work_deg" : 1, "health_deg" : 0, "family_deg" : 1, "relationship_deg" : 1, "money_deg" : 0 ])
                            NetworkManager.shared.fetchWeekCheckData(userID : 1)
                            NetworkManager.shared.fetchWeekStatistics(userID : "1", startDate: "2023-11-06", endDate: "2023-11-12")
                            NetworkManager.shared.fetchMonthStatistics(userID : "1", year: 2023, month: 11)
                            NetworkManager.shared.fetchYearStatistics(userID : "1", year: 2023)
                            NetworkManager.shared.fetchRecordsByDate(userID : "1", year: 2023, month: 11)
                            NetworkManager.shared.fetchRecordsByElement(userID : "1", year: 2023, month: 11, element: "일")
                        }
                }
            }
        }
    }
}
