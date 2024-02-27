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
    
    var noteArray: [(Double, String)] {
        [
            (Double(workPoint), "일"),
            (Double(healthPoint), "건강"),
            (Double(familyPoint), "가족"),
            (Double(relationshipPoint), "관계"),
            (Double(assetPoint), "자산")
        ]
    }

    var maxPoint: Double {
        Double(max(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint))
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
    
    var minPoint: Double {
        Double(min(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint))
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
    static let shared = StatisticsCellViewModel_login()
    @Published var result: StatisticsResult = StatisticsResult(userID: 5, workPer: "0", healthPer: "0", familyPer: "0", relationshipPer: "0", moneyPer: "0"){
        didSet {
            updateNoteArray()
        }
    }
    @Published var noteArray: [(Double, String)] = []
    
    init() {
        updateNoteArray()
    }
    
    func updateNoteArray() {
        noteArray = [
            (Double(result.workPer) ?? 0.0, "일"),
            (Double(result.healthPer) ?? 0.0, "건강"),
            (Double(result.familyPer) ?? 0.0, "가족"),
            (Double(result.relationshipPer) ?? 0.0, "관계"),
            (Double(result.moneyPer) ?? 0.0, "자산")
        ]
    }
    
    lazy var startDate: Date = {
        let startDateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return Calendar.current.date(from: startDateComponents)!
    }()

    lazy var endDate: Date = {
        return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
    }()
    
    func updateValuesFromAPI_Week(startDate: Date, endDate: Date) {
        NetworkManager.shared.fetchWeekStatistics(userID: "id", startDate: Utilities.formatDate(date: startDate), endDate: Utilities.formatDate(date: endDate)) { result in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.result = response.result
                }
                   
            case let .failure(error):
                print("Network request failed: \(error)")
            }
        }
    }

    func updateValuesFromAPI_Month(year: Date, month: Date) {
        NetworkManager.shared.fetchMonthStatistics(userID: "id", year: Int(Utilities.formatDate_Year(date: year))!, month: Int(Utilities.formatDate_Month(date: month))!) { result in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.result = response.result
                }
                   
            case let .failure(error):
                print("Network request failed: \(error)")
            }
        }
    }
    func updateValuesFromAPI_Year(year: Date) {
        NetworkManager.shared.fetchYearStatistics(userID: "id", year: Int(Utilities.formatDate_Year(date: year))!) { result in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.result = response.result
                }
                   
            case let .failure(error):
                print("Network request failed: \(error)")
            }
        }
    }

    var maxPoint: Double {
        Double(max(result.workPer, result.healthPer, result.familyPer, result.relationshipPer, result.moneyPer)) ?? 0
    }
    
    var minPoint: Double {
        Double(min(result.workPer, result.healthPer, result.familyPer, result.relationshipPer, result.moneyPer)) ?? 0
    }
    
    var maxNoteArray: [String] {
        var maxNotes: [String] = []
        let maxPoint = self.maxPoint
        
        for (point, note) in noteArray {
            if maxPoint == point{
                maxNotes.append(note)
            }
        }
        return maxNotes
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


