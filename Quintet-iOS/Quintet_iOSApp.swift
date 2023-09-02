//
//  Quintet_iOSApp.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI
import GoogleSignIn
@main
struct Quintet_iOSApp: App {

    var body: some Scene {
        WindowGroup {
            LoginView().onOpenURL { url in
                print(url)
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

