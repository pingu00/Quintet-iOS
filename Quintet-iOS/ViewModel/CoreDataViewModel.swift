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
        loadUserName()
        //addDummyData()
    }
    
    func addDummyData() {
        let startDate = Calendar.current.date(from: DateComponents(year: 2022, month: 6, day: 26))!
        let endDate = Calendar.current.date(from: DateComponents(year: 2022, month: 8, day: 4))!
        
        var currentDate = startDate
        while currentDate <= endDate {
            let workPoint = Int.random(in: 1...20)
            let healthPoint = Int.random(in: 1...20)
            let familyPoint = Int.random(in: 1...1)
            let relationshipPoint = Int.random(in: 1...20)
            let assetPoint = Int.random(in: 1...1)
            let workNote = "일"
            let healthNote = "건강"
            let familyNote = "가족"
            let assetNote = "자산"
            let relationshipNote = "관계"
            
            addNewData2(date: currentDate, workPoint, healthPoint, familyPoint, assetPoint, relationshipPoint, workNote, healthNote, familyNote, assetNote, relationshipNote)
            
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
    }
    
    
    // 코어데이터에서의 영구 저장소에서 데이터를 비교하거나 가져올때 "일(day)" 을 필터링 하기위해 범위 설정하는 부분을 함수로 따로 구현
    private func createPredicate(from startDate: Date, to endDate: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: startDate)
        let nextDate = calendar.date(byAdding: .day, value: 1, to: endDate)!
        return NSPredicate(format: "date >= %@ AND date < %@", currentDate as NSDate, nextDate as NSDate)
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
    
    
    
    
    
    // MARK: - 임시 더미데이터용 함수
    private func addNewData2(date: Date, _ workPoint: Int, _ healthPoint: Int, _ familyPoint: Int, _ assetPoint: Int, _ relationshipPoint: Int, _ workNote: String, _ healthNote: String, _ familyNote: String, _ assetNote: String, _ relationshipNote: String) {
        let quintetData = QuintetData(context: container.viewContext)
        quintetData.date = date
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
    
    
    //MARK: - TEST : coreData 안의 모든 데이터를 확인하기 위한 테스팅 함수
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
    
    //MARK: 로그인 이후 프로필 이름을 관리하는 함수
    func saveUserName(name : String) {
        userName = name
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    func loadUserName() {
        userName = UserDefaults.standard.string(forKey: "userName") ?? "사용자"
    }
}
