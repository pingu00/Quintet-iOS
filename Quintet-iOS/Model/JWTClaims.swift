//
//  JWTClaims.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/09/02.
//

import Foundation
import SwiftJWT

struct JWTClaims: Claims {
    let id: Int
    let username, email, provider: String
    let iat, exp: Int
}
