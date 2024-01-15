//
//  OAuthResponse.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/09/04.
//

import Foundation


// MARK: - IDTokenResponse
struct TokenResponse: Codable {
    let code: Int
    let message:String
    let result: String?
    let isSuccess: Bool
    
    enum CodingKeys: CodingKey {
        case code
        case message
        case result
        case isSuccess
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
        self.result = try container.decodeIfPresent(String.self, forKey: .result)
        self.isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
    }
}

