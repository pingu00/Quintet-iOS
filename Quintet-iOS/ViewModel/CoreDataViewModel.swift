//
//  DataController.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/28.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    let today = Date()
    
    @Published var currentQuintetData: QuintetData?  // 오늘의 퀸텐 데이터가 있다면 담고 없으면 default 값
    @Published var userName : String = ""
    
    //MARK: - QuintetCheckView에 보여지는 값
    @Published var workPoint = -1
    @Published var healthPoint = -1
    @Published var familyPoint = -1
    @Published var relationshipPoint = -1
    @Published var assetPoint = -1
    
    @Published var workNote = ""
    @Published var healthNote = ""
    @Published var familyNote = ""
    @Published var relationshipNote = ""
    @Published var assetNote = ""
    
    var isAllSelected : Bool {
        workPoint != -1 && familyPoint != -1 && relationshipPoint != -1 && assetPoint != -1 && healthPoint != -1
    }
    
    init() {
        // CoreData 사용을 위한 초기 설정
        container = NSPersistentContainer(name: "CoreDataModel") // 영구저장소의 객체를 생성한다.
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the core data \(error.localizedDescription)")
            }
        }
        
        fetchCurrentQuintetData()
        //addDummyData()
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
    // view 에 로드한다.
    func loadCurrentData() {
        print("Current Time? : \(today)")
        if let currentQuintetData = currentQuintetData {
            print("Today Has Data")
            workPoint = Int(currentQuintetData.workPoint)
            healthPoint = Int(currentQuintetData.healthPoint)
            familyPoint = Int(currentQuintetData.familyPoint)
            relationshipPoint = Int(currentQuintetData.relationshipPoint)
            assetPoint = Int(currentQuintetData.assetPoint)
            
            workNote = currentQuintetData.workNote ?? ""
            healthNote = currentQuintetData.healthNote ?? ""
            familyNote = currentQuintetData.familyNote ?? ""
            relationshipNote = currentQuintetData.relationshipNote ?? ""
            assetNote = currentQuintetData.assetNote ?? ""
        }
        else {
            print("No Data Today")
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
        saveContext()
        return QuintetPointPer(workPointPer: workPointPer,
                               healthPointPer: healthPointPer,
                               familyPointPer: familyPointPer,
                               assetPointPer: assetPointPer,
                               relationshipPointPer: relationshipPointPer,
                               maxValue: maxValue)
    }

    
    // 입력한 날의 퀸텟 데이터를 업데이트해주는 함수.
    func updateQuintetData() {
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
            addNewData()
        }
    }
    //오늘 날짜의 새로운 퀸텟 데이터를 추가하는 함수
    private func addNewData() {
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
    //context 를 영구저장소에 저장한다. context란 영구저장소에 저장되기 전의 중간자 역할.
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
    //MARK: - 비회원 -> 회원 데이터 이전 관련 함수
    // 모든 데이터 확인
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
    // 데이터 가공 및 api 함수 호출
    func convertToMember() {
        print("----------회원 전환 start---------")
        if let allQuintetData = fetchAllQuintetData()  {
            var recordResultArray : [RecordResult] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for (index, quintetData) in allQuintetData.enumerated() {
                let dateString = dateFormatter.string(from: quintetData.date ?? Date())
                let recordResult = RecordResult(
                    id: index + 1,
                    date: dateString,
                    work_deg: Int(quintetData.workPoint),
                    work_doc: quintetData.workNote,
                    health_deg: Int(quintetData.healthPoint),
                    health_doc: quintetData.workNote,
                    family_deg: Int(quintetData.familyPoint),
                    family_doc: quintetData.familyNote,
                    relationship_deg: Int(quintetData.relationshipPoint),
                    relationship_doc: quintetData.relationshipNote,
                    money_deg: Int(quintetData.assetPoint),
                    money_doc: quintetData.assetNote
                )
                print("----------확인 되고 있는 코어데이터 내부 데이터--------------")
                print("Date: \(dateString)")
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
                print("------------------------")
                recordResultArray.append(recordResult)
            }
            NetworkManager.shared.postNonMemberData(data: recordResultArray)
        } else {
            print("회원으로 전환할 데이터가 없습니다.")
        }
    }

    // 비회원 시 사용했던 "CoreDataModel" 엔티티 내부의 데이터 삭제
    func resetCoreDataModel() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoreDataModel") //

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest) // 삭제 요청 실행
            try container.viewContext.save() // 변경사항 저장
            print("Core Data 내부의 데이터가 삭제되었습니다.")
        } catch {
            print("Core Data 데이터 삭제 실패: \(error.localizedDescription)")
        }
    }

    
    
    //MARK: 로그인 이후 프로필 이름을 관리하는 함수
    func saveUserName(name : String) {
        userName = name
        UserDefaults.standard.set(userName, forKey: "userName")
        NetworkManager.shared.EditProfileName(newNickname: userName)
    }
    
    func loadUserName() {
        NetworkManager.shared.fetchProfileName { result in
            switch result {
            case .success(let nickname):
                self.userName = nickname
                // 필요한 경우 UI 업데이트 등 추가 작업 수행
            case .failure(let error):
                self.userName = UserDefaults.standard.string(forKey: "userName") ?? "사용자"
                print("Error fetching user name: \(error)")
            }
        }
    }

    
    func getRecordMetaData(selectedYear: Int, selectedMonth: Int, completion: @escaping ([CalendarMetaData]) -> Void) {
        let calendar = Calendar.current
        var calendarMetaDataArray: [CalendarMetaData] = []

        guard let startDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 2)),
              let endDate = calendar.date(byAdding: .month, value: 1, to: startDate),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: endDate) else {
            completion([])
            return
        }

        let today = calendar.startOfDay(for: startDate)

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

            let daysFromToday = calendar.dateComponents([.day], from: currentDate, to: today).day ?? 0
            let metaData = CalendarMetaData(records: recordsForDate, date: quintetDataArray.first?.date ?? currentDate, offset: daysFromToday)

            if !recordsForDate.isEmpty {
                calendarMetaDataArray.append(metaData)
            }

            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        completion(calendarMetaDataArray)
    }



    //요소별 함수
    func getRecords(for year: Int, month: Int, filterKeyPath: KeyPath<QuintetData, Int64>, iconClosure: @escaping (Int64) -> String, noteKeyPath: KeyPath<QuintetData, String?>, completion: @escaping ([RecordMetaData]) -> Void) {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        let endDateComponents = DateComponents(year: year, month: month + 1, day: 0)
        
        guard let startDate = calendar.date(from: startDateComponents),
              let endDate = calendar.date(from: endDateComponents) else {
            completion([])
            return
        }
        
        let quintetData = getQuintetData(from: startDate, to: endDate)
        let filteredData = quintetData.filter { $0[keyPath: filterKeyPath] >= 0 }
        
        let sortedRecords = filteredData.sorted(by: { ($0.date ?? Date()) > ($1.date ?? Date()) }).prefix(5).reversed()
        
        let recordMetaData = sortedRecords.map { data in
            let icon = iconClosure(data[keyPath: filterKeyPath])
            let date = data.date ?? Date()
            let formattedDate = formatDate(date: date)
            let subtitle = data[keyPath: noteKeyPath] ?? ""
            return RecordMetaData(records: [
                Record(icon: icon, title: formattedDate, subtitle: subtitle)
            ])
        }
        
        completion(recordMetaData)
    }

    func getHealthRecords(for year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void) {
        let iconClosure: (Int64) -> String = { healthPoint in
            return healthPoint == 0 ? "XOn" : (healthPoint == 1 ? "TriangleOn" : "CircleOn")
        }
        
        getRecords(for: year, month: month, filterKeyPath: \.healthPoint, iconClosure: iconClosure, noteKeyPath: \.healthNote, completion: completion)
    }


    func getAssetRecords(for year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void) {
        let iconClosure: (Int64) -> String = { assetPoint in
            return assetPoint == 0 ? "XOn" : (assetPoint == 1 ? "TriangleOn" : "CircleOn")
        }
        
        getRecords(for: year, month: month, filterKeyPath: \.assetPoint, iconClosure: iconClosure, noteKeyPath: \.assetNote, completion: completion)
    }

    func getFamilyRecords(for year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void) {
        let iconClosure: (Int64) -> String = { familyPoint in
            return familyPoint == 0 ? "XOn" : (familyPoint == 1 ? "TriangleOn" : "CircleOn")
        }
        
        getRecords(for: year, month: month, filterKeyPath: \.familyPoint, iconClosure: iconClosure, noteKeyPath: \.familyNote, completion: completion)
    }

    func getRelationshipRecords(for year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void) {
        let iconClosure: (Int64) -> String = { relationshipPoint in
            return relationshipPoint == 0 ? "XOn" : (relationshipPoint == 1 ? "TriangleOn" : "CircleOn")
        }
        
        getRecords(for: year, month: month, filterKeyPath: \.relationshipPoint, iconClosure: iconClosure, noteKeyPath: \.relationshipNote, completion: completion)
    }

    func getWorkRecords(for year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void)  {
        let iconClosure: (Int64) -> String = { workPoint in
            return workPoint == 0 ? "XOn" : (workPoint == 1 ? "TriangleOn" : "CircleOn")
        }
        
        getRecords(for: year, month: month, filterKeyPath: \.workPoint, iconClosure: iconClosure, noteKeyPath: \.workNote, completion: completion)
    }


    //날짜를 2023.08.10 처럼 바꿔주는 함수
    func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return String(format: "%04d. %02d. %02d", year, month, day)
    }
    
    
}
