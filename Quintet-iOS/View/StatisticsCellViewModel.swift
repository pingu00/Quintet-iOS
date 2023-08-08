//
//  StatisticsCellViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/28.
//

import SwiftUI

class StatisticsCellViewModel: ObservableObject {
    @Published private var workPoint = 0
    @Published private var healthPoint = 0
    @Published private var familyPoint = 0
    @Published private var relationshipPoint = 0
    @Published private var assetPoint = 0
    
    lazy var startDate: Date = {
        let startDateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return Calendar.current.date(from: startDateComponents)!
    }()

    lazy var endDate: Date = {
        return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
    }()

    private let coreDataViewModel: CoreDataViewModel
    
    init(coreDataViewModel: CoreDataViewModel) {
        self.coreDataViewModel = coreDataViewModel
        updateValuesFromCoreData(startDate: startDate, endDate: endDate)
    }
    
    func updateValuesFromCoreData(startDate: Date, endDate: Date) {
        let quintetDataArray = coreDataViewModel.getQuintetData(from: startDate, to: endDate)
        
        workPoint = quintetDataArray.reduce(0) { $0 + Int($1.workPoint) }
        healthPoint = quintetDataArray.reduce(0) { $0 + Int($1.healthPoint) }
        familyPoint = quintetDataArray.reduce(0) { $0 + Int($1.familyPoint) }
        relationshipPoint = quintetDataArray.reduce(0) { $0 + Int($1.relationshipPoint) }
        assetPoint = quintetDataArray.reduce(0) { $0 + Int($1.assetPoint) }
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
