//
//  StatisticsCellViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/28.
//

import SwiftUI

class StatisticsCellViewModel: ObservableObject {
    @Published private var workPoint = 1
    @Published private var healthPoint = 2
    @Published private var familyPoint = 2
    @Published private var relationshipPoint = 5
    @Published private var assetPoint = 5
    
    
    var totalPoint: Int {
        workPoint + healthPoint + familyPoint + relationshipPoint + assetPoint
    }
    
    var noteArray: [(Int, String)] {
        [
            (workPoint, "일"),
            (healthPoint, "건강"),
            (familyPoint, "가족"),
            (relationshipPoint, "관계"),
            (assetPoint, "자산")
        ]
    }

    var maxPoint: Int {
        max(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint)
    }
    
    var maxNoteArray: [String]{
        var maxNotes: [String] = []
        let maxPoint = self.maxPoint
        
        for (point, note) in noteArray {
            if maxPoint == point{
                maxNotes.append(note)
            }
                
        }
        return maxNotes
    }
    
    

    
    
}
