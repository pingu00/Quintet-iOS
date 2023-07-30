//
//  DataController.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/28.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {

    @Published var currentQuintetData: QuintetData? // 오늘의 퀸텐 데이터가 있다면 담고 없으면 default 값
    let container: NSPersistentContainer

    init() {
        // CoreData 사용을 위한 초기 설정
        container = NSPersistentContainer(name: "CoreDataModel") // 영구저장소의 객체를 생성한다.
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the core data \(error.localizedDescription)")
            }
        }
        
    }
   
    
    // 코어데이터에서의 영구 저장소에서 데이터를 비교하거나 가져올때 "일(day)" 을 필터링 하기위해 범위 설정하는 부분을 함수로 따로 구현
    private func createPredicate(for date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: date)
        return NSPredicate(format: "date >= %@ AND date < %@",
                           currentDate as NSDate,
                           calendar.date(byAdding: .day, value: 1, to: currentDate)! as NSDate)
    }

    //"일(day)" 로 필터링 된 QuintetData 하나를 반환 한다.
    private func fetchQuintetData(for date: Date) -> QuintetData? {
        let request: NSFetchRequest<QuintetData> = QuintetData.fetchRequest()
        request.predicate = createPredicate(for: date)

        do {
            let results = try container.viewContext.fetch(request)
            return results.first
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }

    // 영구저장소 내의 오늘의 날짜를 가진 데이터가 있는지 확인하는 함수.
    func hasDataForCurrentDate() -> Bool {
        if let todaysData = fetchQuintetData(for: Date()) {
            currentQuintetData = todaysData
            return true
        }
        return false
    }

    //오늘 날짜의 새로운 퀸텟 데이터를 추가하는 함수
    func addQuintetData(_ workPoint: Int, _ healthPoint: Int, _ familyPoint: Int, _ assetPoint: Int, _ relationshipPoint: Int, _ workNote: String, _ healthNote: String, _ familyNote: String, _ assetNote: String, _ relationshipNote: String) {
        let quintetData = QuintetData(context: container.viewContext)
        quintetData.date = Date()
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
    func updateQuintetData(_ date: Date, _ workPoint: Int, _ healthPoint: Int, _ familyPoint: Int, _ assetPoint: Int, _ relationshipPoint: Int, _ workNote: String, _ healthNote: String, _ familyNote: String, _ assetNote: String, _ relationshipNote: String) {
        if let savedQuintetData = fetchQuintetData(for: date) {
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
            addQuintetData(workPoint, healthPoint, familyPoint, assetPoint, relationshipPoint, workNote, healthNote, familyNote, assetNote, relationshipNote)
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
            for quintetData in allQuintetData {
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
                print("------------")
            }
        } else {
            print("No data found.")
        }
    }
}
