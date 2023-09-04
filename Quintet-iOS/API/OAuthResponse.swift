//
//  OAuthResponse.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/09/04.
//

import Foundation


// MARK: - IDTokenResponse
struct GoogleIdTokenResponse: Codable {
    let code: Int
    let message:String
    let result: String?
    let isSuccess: Bool
}
