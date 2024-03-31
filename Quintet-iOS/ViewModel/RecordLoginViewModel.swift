//
//  RecordLoginViewModel.swift
//  Quintet-iOS
//
//  Created by 옥재은 on 1/31/24.
//

import Foundation

class RecordLoginViewModel: ObservableObject {
    private let netWorkManager: NetworkManager = NetworkManager()
        

    
    func getCalendar(year: Int, month: Int, completion: @escaping ([CalendarMetaData]) -> Void) {
        var fetchedCalendar: [RecordResult] = []
        
        // 현재 날짜
        let today = Date()
        
        // 네트워크 요청을 통해 데이터를 가져옴
        netWorkManager.fetchRecordsByDate(userID: "id", year: year, month: month) { result in
            switch result {
            case .success(let records):
                fetchedCalendar = records
                print(fetchedCalendar)
                
                // 날짜를 Date 형식으로 변환하여 CalendarMetaData에 추가
                var processedCalendar: [CalendarMetaData] = []
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                for record in fetchedCalendar {
                    guard let recordDate = dateFormatter.date(from: record.date) else {
                        continue
                    }
                    
                    // 현재 날짜로부터 해당 날짜까지의 일 수를 계산 -> offset 계산
                    let calendar = Calendar.current
                    let daysFromToday = calendar.dateComponents([.day], from: today, to: recordDate).day ?? 0
                    
                    // 각 요소의 deg 값을 확인하고 해당하는 아이콘을 설정
                    let workIcon = self.iconForDeg(record.work_deg ?? 0)
                    let healthIcon = self.iconForDeg(record.health_deg ?? 0)
                    let familyIcon = self.iconForDeg(record.family_deg ?? 0)
                    let relationshipIcon = self.iconForDeg(record.relationship_deg ?? 0)
                    let moneyIcon = self.iconForDeg(record.money_deg ?? 0)
                    
                    // Record 객체들을 생성하고 tasks 배열에 추가
                    let tasks = [
                        Record(icon: workIcon, title: "일", subtitle: record.work_doc ?? ""),
                        Record(icon: healthIcon, title: "건강", subtitle: record.health_doc ?? ""),
                        Record(icon: familyIcon, title: "가족", subtitle: record.family_doc ?? ""),
                        Record(icon: relationshipIcon, title: "관계", subtitle: record.relationship_doc ?? ""),
                        Record(icon: moneyIcon, title: "자산", subtitle: record.money_doc ?? "")
                    ]
                    
                    // CalendarMetaData를 생성
                    let metaData = CalendarMetaData(id: UUID().uuidString,
                                                    records: tasks,
                                                    date: recordDate,
                                                    offset: daysFromToday)
                    processedCalendar.append(metaData)
                }
                
                // 완료 처리 클로저 호출
                completion(processedCalendar)
                
            case .failure(let error):
                print("실패!!!!")
                completion([])
            }
        }
    }



    

    func getRecord(for element: String, year: Int, month: Int, completion: @escaping ([RecordMetaData]) -> Void) {
        var fetchedRecords: [RecordResult] = []
        var processedData: [RecordMetaData] = []

        netWorkManager.fetchRecordsByElement(userID: "id", year: year, month: month, element: element) { result in
            switch result {
            case .success(let records):
                fetchedRecords = records
                fetchedRecords.sort { $0.date > $1.date }

                let top5Records = Array(fetchedRecords.prefix(5))
                let sortedRecords = top5Records.sorted { $0.date < $1.date }

                processedData = self.processRecords(sortedRecords, for: element)
                completion(processedData)

            case .failure(let error):
                print("Error fetching records for element:", error)
                completion([])
            }
        }
    }


    private func processRecords(_ records: [RecordResult], for element: String) -> [RecordMetaData] {
        var processedData: [RecordMetaData] = []

        for record in records {
            let (degKeyPath, docKeyPath) = getKeyPaths(for: element)
            let degValue = record[keyPath: degKeyPath] ?? 0
            let docValue = record[keyPath: docKeyPath] ?? ""
            let icon = getIcon(for: degValue)
            if let title = formatDateFromString(dateString: record.date) {
                processedData.append(RecordMetaData(records: [Record(id: "id", icon: icon, title: title, subtitle: docValue)]))
            }
        }

        return processedData
    }


    private func getKeyPaths(for element: String) -> (KeyPath<RecordResult, Int?>, KeyPath<RecordResult, String?>) {
        var degKeyPath: KeyPath<RecordResult, Int?> = \RecordResult.work_deg
        var docKeyPath: KeyPath<RecordResult, String?> = \RecordResult.work_doc

        switch element {
        case "일":
            degKeyPath = \RecordResult.work_deg
            docKeyPath = \RecordResult.work_doc
        case "건강":
            degKeyPath = \RecordResult.health_deg
            docKeyPath = \RecordResult.health_doc
        case "가족":
            degKeyPath = \RecordResult.family_deg
            docKeyPath = \RecordResult.family_doc
        case "관계":
            degKeyPath = \RecordResult.relationship_deg
            docKeyPath = \RecordResult.relationship_doc
        case "자산":
            degKeyPath = \RecordResult.money_deg
            docKeyPath = \RecordResult.money_doc
        default:
            break
        }

        return (degKeyPath, docKeyPath)
    }

    
    func iconForDeg(_ deg: Int?) -> String {
        guard let deg = deg else {
            return "Unknown"
        }
        switch deg {
        case 0:
            return "XOn"
        case 1:
            return "TriangleOn"
        case 2:
            return "CircleOn"
        default:
            return "Unknown"
        }
    }

    private func getIcon(for degValue: Int) -> String {
        switch degValue {
        case 0:
            return "XOn"
        case 1:
            return "TriangleOn"
        case 2:
            return "CircleOn"
        default:
            return ""
        }
    }

    func formatDateFromString(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy. MM. dd"
            return dateFormatter.string(from: date)
        } else {
            // 날짜 변환 실패 시 nil 반환
            return nil
        }
    }

}
