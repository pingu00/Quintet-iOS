//
//  StatisticsCellViewModel.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/07/28.
//

import SwiftUI

class StatisticsCellViewModel: CoreDataViewModel {
    lazy var startDate: Date = {
        let startDateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return Calendar.current.date(from: startDateComponents)!
    }()

    lazy var endDate: Date = {
        return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
    }()
    
    override init() {
        super.init()
        updateValuesFromCoreData(startDate: startDate, endDate: endDate)
    }
    
    func updateValuesFromCoreData(startDate: Date, endDate: Date) {
        let quintetDataArray = getQuintetData(from: startDate, to: endDate)
        
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
    
    var minPoint: Int {
        min(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint)
    }
    
    var minNoteArray: [String]{
        var minNotes: [String] = []
        let minPoint = self.minPoint
        
        for (point, note) in noteArray {
            if minPoint == point {
                minNotes.append(note)
            }
        }
        
        return minNotes
    }

    var selectedText: String? {
        if maxNoteArray.count >= 2 && minNoteArray.count == 1 {
            let maxNote: String? = nil
            let minNote: String? = minNoteArray.first
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
            
        } else if maxNoteArray.count == 1 && minNoteArray.count >= 2 {
            let maxNote: String? = maxNoteArray.first
            let minNote: String? = nil
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
            
        } else {
            let maxNote: String? = maxNoteArray.first
            let minNote: String? = minNoteArray.first
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
        }
    }
}

class StatisticsCellViewModel_login: ObservableObject {
    @Published var workPointPer: String = ""
    @Published var healthPointPer: String = ""
    @Published var familyPointPer: String = ""
    @Published var relationshipPointPer: String = ""
    @Published var assetPointPer: String = ""
    
    private let netWorkManager: NetworkManager
    
    lazy var startDate: Date = {
        let startDateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return Calendar.current.date(from: startDateComponents)!
    }()

    lazy var endDate: Date = {
        return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
    }()
    
    init(netWorkManager: NetworkManager) {
        self.netWorkManager = netWorkManager
    }
    
    func updateValuesFromAPI_Week(startDate: Date, endDate: Date) {
        netWorkManager.fetchWeekStatistics(userID: "id", startDate: Utilities.formatDate(date: startDate), endDate: Utilities.formatDate(date: endDate))
    }

    func updateValuesFromAPI_Month(year: Date, month: Date) {
        netWorkManager.fetchMonthStatistics(userID: "id", year: Int(Utilities.formatDate_Year(date: year))!, month: Int(Utilities.formatDate_Month(date: month))!)
    }
    func updateValuesFromAPI_Year(year: Date) {
        netWorkManager.fetchYearStatistics(userID: "id", year: Int(Utilities.formatDate_Year(date: year))!)
    }
    
    var noteArray: [(Int, String)] {
        [
            (Int(workPointPer) ?? 0, "일"),
            (Int(healthPointPer) ?? 0, "건강"),
            (Int(familyPointPer) ?? 0, "가족"),
            (Int(relationshipPointPer) ?? 0, "관계"),
            (Int(assetPointPer) ?? 0, "자산")
        ]
    }

    var maxPoint: Int {
        max(Int(workPointPer) ?? 0, Int(healthPointPer) ?? 0, Int(familyPointPer) ?? 0, Int(relationshipPointPer) ?? 0, Int(assetPointPer) ?? 0)
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
    
    var minPoint: Int {
        min(Int(workPointPer) ?? 0, Int(healthPointPer) ?? 0, Int(familyPointPer) ?? 0, Int(relationshipPointPer) ?? 0, Int(assetPointPer) ?? 0)
    }
    
    var minNoteArray: [String]{
        var minNotes: [String] = []
        let minPoint = self.minPoint
        
        for (point, note) in noteArray {
            if minPoint == point {
                minNotes.append(note)
            }
        }
        
        return minNotes
    }

    var selectedText: String? {
        if maxNoteArray.count >= 2 && minNoteArray.count == 1 {
            let maxNote: String? = nil
            let minNote: String? = minNoteArray.first
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
            
        } else if maxNoteArray.count == 1 && minNoteArray.count >= 2 {
            let maxNote: String? = maxNoteArray.first
            let minNote: String? = nil
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
            
        } else {
            let maxNote: String? = maxNoteArray.first
            let minNote: String? = minNoteArray.first
            
            let matchingAdvice = adviceData.first { advice in
                return advice.high == maxNote && advice.low == minNote
            }
            
            return matchingAdvice?.content
        }
    }
}


