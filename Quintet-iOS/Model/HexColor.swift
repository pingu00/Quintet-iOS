//
//  HexColor.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/07/14.
//

import SwiftUI

//사용법: 앞에 0x를 붙이고 hex코드를 입력하여 사용. opacity는 필요에 따라 설정
//ex(Color(hex: 0x5B62FF))
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
