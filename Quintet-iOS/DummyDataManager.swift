//
//  DummyDataManager.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/07/29.
//

import SwiftUI

// MARK: - 임시로 만든 더미 데이터 type
struct HappinessInfo{
    var date: String
    var happiness : [Int]?
}

// MARK: - 임시 data를 관리하는 class
class DummyDataManager{
   static var data: [HappinessInfo] = [
        HappinessInfo(date: "2023-07-23-일", happiness: [1, 2, 2, 0, 1]),
        HappinessInfo(date: "2023-07-24-월"),
        HappinessInfo(date: "2023-07-25-화", happiness: [1, 2, 1, 0, 0]),
        HappinessInfo(date: "2023-07-26-수"),
        HappinessInfo(date: "2023-07-27-목"),
        HappinessInfo(date: "2023-07-28-금", happiness: [1, 1, 2, 0, 1]),
        HappinessInfo(date: "2023-07-29-토", happiness: [0, 2, 2, 0, 1])
    ]
    
    static func getDummyData() -> [HappinessInfo]{
        return self.data
    }
}

