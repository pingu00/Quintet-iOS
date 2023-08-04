//
//  StatisticsCellViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/28.
//

import SwiftUI

class StatisticsCellViewModel: ObservableObject {
    @Published private var workPoint = 5
    @Published private var healthPoint = 3
    @Published private var familyPoint = 1
    @Published private var relationshipPoint = 4
    @Published private var assetPoint = 1
    
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 1))!
    let endDate = Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 7))!

    
    private let coreDataViewModel: CoreDataViewModel
    
    init(coreDataViewModel: CoreDataViewModel) {
        self.coreDataViewModel = coreDataViewModel
        updateValuesFromCoreData(startDate: startDate, endDate: endDate)
    }
    
    func updateValuesFromCoreData(startDate: Date, endDate: Date) {
        _ = coreDataViewModel.getQuintetData(from: startDate, to: endDate)
        
    }
    
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
