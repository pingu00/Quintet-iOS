//
//  DataController.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/28.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject {

    @Published var currentQuintetData: QuintetData?  // 오늘의 퀸텐 데이터가 있다면 담고 없으면 default 값
    @Published var userName = "로니"
    
    let container: NSPersistentContainer
    let today : Date
    
    
    init() {
        // CoreData 사용을 위한 초기 설정
        container = NSPersistentContainer(name: "CoreDataModel") // 영구저장소의 객체를 생성한다.
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the core data \(error.localizedDescription)")
            }
        }
        today = Date()
    }
   
    
    // 코어데이터에서의 영구 저장소에서 데이터를 비교하거나 가져올때 "일(day)" 을 필터링 하기위해 범위 설정하는 부분을 함수로 따로 구현
    private func createPredicate(from startDate: Date, to endDate: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: startDate)
        let nextDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: endDate)!)
        return NSPredicate(format: "(date >= %@) AND (date < %@)", currentDate as NSDate, nextDate as NSDate)
    }



    
    // 현재 클래스의 프로퍼티인 currentQuintetData를 패치
    func fetchCurrentQuintetData() {
        let request: NSFetchRequest<QuintetData> = QuintetData.fetchRequest()
        request.predicate = createPredicate(from: today, to: today)

        do {
            let results = try container.viewContext.fetch(request)
            currentQuintetData = results.first
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    // startDate 부터 endDate 까지의 QuintetData 를 [QuintetData] 로 반환 _ 캘린더에서 데이터 보여줄때 이거 쓰시면 됩니다!
    func getQuintetData(from startDate: Date, to endDate: Date) -> [QuintetData] {
        let request: NSFetchRequest<QuintetData> = QuintetData.fetchRequest()
        request.predicate = createPredicate(from: startDate, to: endDate)

        do {
            let results = try container.viewContext.fetch(request)
            return results
        } catch {
            print("Error getting data: \(error)")
            return []
        }
    }

    
    //startDate 부터 endDate 까지의 QuintetData의 요소별 퍼센트를 반환!
    func getPercentOfData(from startDate: Date, to endDate: Date) -> QuintetPointPer {
        let datas = getQuintetData(from: startDate, to: endDate) // 해당 날짜의 퀸텟 데이터를 가져옴
        var sumPoint = [0,0,0,0,0]
        for data in datas {
            sumPoint[0] += Int(data.workPoint)
            sumPoint[1] += Int(data.healthPoint)
            sumPoint[2] += Int(data.familyPoint)
            sumPoint[3] += Int(data.assetPoint)
            sumPoint[4] += Int(data.relationshipPoint)
        }
        
        let totalSum = sumPoint.reduce(0, +)
        
        let workPointPer = Double(sumPoint[0]) / Double(totalSum) * 100.0
        let healthPointPer = Double(sumPoint[1]) / Double(totalSum) * 100.0
        let familyPointPer = Double(sumPoint[2]) / Double(totalSum) * 100.0
        let assetPointPer = Double(sumPoint[3]) / Double(totalSum) * 100.0
        let relationshipPointPer = Double(sumPoint[4]) / Double(totalSum) * 100.0
        let maxPercentage = max(workPointPer, healthPointPer, familyPointPer, assetPointPer, relationshipPointPer)
         
        var maxValue: [String] = []
        switch maxPercentage {
        case workPointPer:
            maxValue.append("일")
        case healthPointPer:
            maxValue.append("건강")
        case familyPointPer:
            maxValue.append("가족")
        case assetPointPer:
            maxValue.append("자산")
        case relationshipPointPer:
            maxValue.append("관계")
        default:
            break
        }
        
        return QuintetPointPer(workPointPer: workPointPer,
                               healthPointPer: healthPointPer,
                               familyPointPer: familyPointPer,
                               assetPointPer: assetPointPer,
                               relationshipPointPer: relationshipPointPer,
                               maxValue: maxValue)
    }

    //오늘 날짜의 새로운 퀸텟 데이터를 추가하는 함수
    private func addNewData(_ workPoint: Int, _ healthPoint: Int, _ familyPoint: Int, _ assetPoint: Int, _ relationshipPoint: Int, _ workNote: String, _ healthNote: String, _ familyNote: String, _ assetNote: String, _ relationshipNote: String) {
        let quintetData = QuintetData(context: container.viewContext)
        quintetData.date = today
        quintetData.workPoint = Int64(workPoint)
        quintetData.healthPoint = Int64(healthPoint)
        quintetData.familyPoint = Int64(familyPoint)
        quintetData.relationshipPoint = Int64(relationshipPoint)
        quintetData.assetPoint = Int64(assetPoint)
        quintetData.workNote = workNote
        quintetData.healthNote = healthNote
        quintetData.familyNote = familyNote
        quintetData.relationshipNote = relationshipNote
        quintetData.assetNote = assetNote

        saveContext()
    }
    // 입력한 날의 퀸텟 데이터를 업데이트해주는 함수.
    func updateQuintetData(_ workPoint: Int, _ healthPoint: Int, _ familyPoint: Int, _ assetPoint: Int, _ relationshipPoint: Int, _ workNote: String, _ healthNote: String, _ familyNote: String, _ assetNote: String, _ relationshipNote: String) {
        if let savedQuintetData = currentQuintetData {
            savedQuintetData.workPoint = Int64(workPoint)
            savedQuintetData.healthPoint = Int64(healthPoint)
            savedQuintetData.familyPoint = Int64(familyPoint)
            savedQuintetData.relationshipPoint = Int64(relationshipPoint)
            savedQuintetData.assetPoint = Int64(assetPoint)
            savedQuintetData.workNote = workNote
            savedQuintetData.healthNote = healthNote
            savedQuintetData.familyNote = familyNote
            savedQuintetData.relationshipNote = relationshipNote
            savedQuintetData.assetNote = assetNote

            saveContext()
        } else {
            addNewData(workPoint, healthPoint, familyPoint, assetPoint, relationshipPoint, workNote, healthNote, familyNote, assetNote, relationshipNote)
        }
    }

    //context 를 영구저장소에 저장한다. context란 영구저장소에 저장되기 전의 중간자 역할.
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
    
    // coreData 안의 모든 데이터를 확인하기 위한 테스팅 함수
    func fetchAllQuintetData() -> [QuintetData]? {
            let request: NSFetchRequest<QuintetData> = QuintetData.fetchRequest()
            
            do {
                let results = try container.viewContext.fetch(request)

                return results
            } catch {
                print("Error fetching data: \(error)")
                return nil
            }
        }
    func checkAllCoreData() {
        if let allQuintetData = fetchAllQuintetData()  {
            print("------------------------")
            print("All Data in CoreData store")
            for quintetData in allQuintetData {
                print("------------------------")
                print("Date: \(quintetData.date ?? Date())")
                print("Work Point: \(quintetData.workPoint)")
                print("Health Point: \(quintetData.healthPoint)")
                print("Family Point: \(quintetData.familyPoint)")
                print("Relationship Point: \(quintetData.relationshipPoint)")
                print("Asset Point: \(quintetData.assetPoint)")
                print("Work Note: \(quintetData.workNote ?? "")")
                print("Health Note: \(quintetData.healthNote ?? "")")
                print("Family Note: \(quintetData.familyNote ?? "")")
                print("Relationship Note: \(quintetData.relationshipNote ?? "")")
                print("Asset Note: \(quintetData.assetNote ?? "")")
            }
        } else {
            print("No data found.")
        }
    }
    func saveUserName() {
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    func loadUserName() {
        if let savedUserName = UserDefaults.standard.string(forKey: "userName") {
            userName = savedUserName
        }
    }
    
    //날짜별
    func getRecordMetaData(selectedYear: Int, selectedMonth: Int) -> [CalendarMetaData] {
        let calendar = Calendar.current
        var calendarMetaDataArray: [CalendarMetaData] = []
        
        guard let startDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)),
              let endDate = calendar.date(byAdding: .month, value: 1, to: startDate),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: endDate) else {
            return []
        }
        
        let today = calendar.startOfDay(for: Date()) // Get the start of today
        
        var currentDate = startDate
        
        while currentDate <= lastDayOfMonth {
            let quintetDataArray = getQuintetData(from: currentDate, to: calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate)
            
            var recordsForDate: [Record] = []
            
            for data in quintetDataArray {
                if data.workPoint >= 0 && data.workPoint <= 2 {
                    let workIcon = data.workPoint == 0 ? "XOn" : (data.workPoint == 1 ? "TriangleOn" : "CircleOn")
                    let healthIcon = data.healthPoint == 0 ? "XOn" : (data.healthPoint == 1 ? "TriangleOn" : "CircleOn")
                    let familyIcon = data.familyPoint == 0 ? "XOn" : (data.familyPoint == 1 ? "TriangleOn" : "CircleOn")
                    let assetIcon = data.assetPoint == 0 ? "XOn" : (data.assetPoint == 1 ? "TriangleOn" : "CircleOn")
                    let relationshipIcon = data.relationshipPoint == 0 ? "XOn" : (data.relationshipPoint == 1 ? "TriangleOn" : "CircleOn")
                    
                    let tasks = [
                        Record(icon: workIcon, title: "일", subtitle: data.workNote ?? ""),
                        Record(icon: healthIcon, title: "건강", subtitle: data.healthNote ?? ""),
                        Record(icon: familyIcon, title: "가족", subtitle: data.familyNote ?? ""),
                        Record(icon: relationshipIcon, title: "관계", subtitle: data.relationshipNote ?? ""),
                        Record(icon: assetIcon, title: "자산", subtitle: data.assetNote ?? "")
                    ]
                    
                    recordsForDate.append(contentsOf: tasks)
                }
            }
            
            if !recordsForDate.isEmpty && currentDate == today {
                let daysFromToday = calendar.dateComponents([.day], from: currentDate, to: today).day ?? 0
                
                let metaData = CalendarMetaData(records: recordsForDate, date: currentDate, offset: daysFromToday)
                calendarMetaDataArray.append(metaData)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return calendarMetaDataArray
    }

    //요소별
    
    func getHealthRecords(for year: Int, month: Int) -> [RecordMetaData] {
        return getElementData(for: year, month: month, filterKeyPath: \.healthPoint, filterNoteKeyPath: \.healthNote, title: "건강")
    }

    func getAssetRecords(for year: Int, month: Int) -> [RecordMetaData] {
        return getElementData(for: year, month: month, filterKeyPath: \.assetPoint, filterNoteKeyPath: \.assetNote, title: "자산")
    }

    func getFamilyRecords(for year: Int, month: Int) -> [RecordMetaData] {
        return getElementData(for: year, month: month, filterKeyPath: \.familyPoint, filterNoteKeyPath: \.familyNote, title: "가족")
    }

    func getRelationshipRecords(for year: Int, month: Int) -> [RecordMetaData] {
        return getElementData(for: year, month: month, filterKeyPath: \.relationshipPoint, filterNoteKeyPath: \.relationshipNote, title: "관계")
    }

    func getWorkRecords(for year: Int, month: Int) -> [RecordMetaData] {
        return getElementData(for: year, month: month, filterKeyPath: \.workPoint, filterNoteKeyPath: \.workNote, title: "일")
    }

    
    func getElementData(for year: Int, month: Int, filterKeyPath: KeyPath<QuintetData, Int64>, filterNoteKeyPath: KeyPath<QuintetData, String?>, title: String) -> [RecordMetaData] {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        let endDateComponents = DateComponents(year: year, month: month + 1, day: 0)
        
        guard let startDate = calendar.date(from: startDateComponents),
              let endDate = calendar.date(from: endDateComponents) else {
            return []
        }
        
        let quintetData = getQuintetData(from: startDate, to: endDate)
        
        let filteredRecords = quintetData.filter { $0[keyPath: filterKeyPath] >= 0 }
        
        let sortedRecords = filteredRecords.sorted(by: { ($0.date ?? Date()) < ($1.date ?? Date()) }).prefix(5)
        
        return sortedRecords.map { data in
            let icon = data[keyPath: filterKeyPath] == 0 ? "XOn" : (data[keyPath: filterKeyPath] == 1 ? "TriangleOn" : "CircleOn")
            let date = data.date ?? Date()
            let subtitle = data[keyPath: filterKeyPath] == 0 ? nil : data[keyPath: filterNoteKeyPath]
            let title = formatDate(date: date)
            
            return RecordMetaData(records: [
                Record(icon: icon, title: title, subtitle: subtitle ?? "")
            ])
        }
    }

    //날짜를 2023.08.10 처럼 바꿔주는 함수
    func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return String(format: "%04d.%02d.%02d", year, month, day)
    }
}
