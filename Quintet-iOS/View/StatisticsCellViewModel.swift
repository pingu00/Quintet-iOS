//
//  StatisticsCellViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/28.
//

import SwiftUI

class StatisticsCellViewModel: ObservableObject {
    @Published private var workPoint = 1
    @Published private var healthPoint = 1
    @Published private var familyPoint = 1
    @Published private var relationshipPoint = 1
    @Published private var assetPoint = 1
    
    private let coreDataViewModel: CoreDataViewModel
    
    init(coreDataViewModel: CoreDataViewModel) {
        self.coreDataViewModel = coreDataViewModel
        updateWeekValuesFromCoreData()
    }
    
    func updateWeekValuesFromCoreData() {
        let coreDataValues = coreDataViewModel.getQuintetData(for: Date())
        
        workPoint = Int(coreDataValues?.workPoint ?? 3)
        healthPoint = Int(coreDataValues?.healthPoint ?? 2)
        familyPoint = Int(coreDataValues?.familyPoint ?? 3)
        relationshipPoint = Int(coreDataValues?.relationshipPoint ?? 5)
        assetPoint = Int(coreDataValues?.assetPoint ?? 1)
    }
    
    func updateMonthValuesFromCoreData() {
        let coreDataValues = coreDataViewModel.getQuintetData(for: Date())
        
        workPoint = Int(coreDataValues?.workPoint ?? 1)
        healthPoint = Int(coreDataValues?.healthPoint ?? 7)
        familyPoint = Int(coreDataValues?.familyPoint ?? 2)
        relationshipPoint = Int(coreDataValues?.relationshipPoint ?? 5)
        assetPoint = Int(coreDataValues?.assetPoint ?? 5)
    }
    
    func updateYearValuesFromCoreData() {
//        let calendar = Calendar.current
//        guard let startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
//              let endDate = calendar.date(from: DateComponents(year: year, month: 12, day: 31)) else {
//            // 날짜를 계산하는 데 실패한 경우
//            return
//        }

//        let coreDataValues = coreDataViewModel.getQuintetData(for: startDate, endDate: endDate)
        let coreDataValues = coreDataViewModel.getQuintetData(for: Date())
        
        workPoint = Int(coreDataValues?.workPoint ?? 6)
        healthPoint = Int(coreDataValues?.healthPoint ?? 2)
        familyPoint = Int(coreDataValues?.familyPoint ?? 2)
        relationshipPoint = Int(coreDataValues?.relationshipPoint ?? 4)
        assetPoint = Int(coreDataValues?.assetPoint ?? 1)
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
