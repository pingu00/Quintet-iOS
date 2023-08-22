//
//  Quintet_iOSApp.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

@main
struct Quintet_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onAppear {
                    NetworkManager.shared.fetchWeekCheckData(userID : 2)
                    NetworkManager.shared.fetchWeekStatistics(userID : "2", startDate: "2023-08-13", endDate: "2023-08-19")
                    NetworkManager.shared.fetchMonthStatistics(userID : "2", year: 2023, month: 8)
                    NetworkManager.shared.fetchYearStatistics(userID : "2", year: 2023)
                }
        }
    }
}
