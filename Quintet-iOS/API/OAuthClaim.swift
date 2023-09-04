//
//  OAuthClaim.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/09/04.
//

import Foundation
import SwiftJWT

struct GoogleJWTClaims: Claims {
    let id: Int
    let username, email, provider: String
    let iat, exp: Int
}
