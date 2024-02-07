//
//  RecordLoginViewModel.swift
//  Quintet-iOS
//
//  Created by 옥재은 on 1/31/24.
//

import Foundation

class RecordLoginViewModel: ObservableObject {

    @Published private var viewModel = DateViewModel()
    private let netWorkManager: NetworkManager = NetworkManager()
    
    func getCalendar(completion: @escaping ([CalendarMetaData]) -> Void) {
        var fetchedCalendar: [RecordResult] = []
        var processedCalendar: [CalendarMetaData] = []
        
        // 현재 날짜
        let today = Date()
        
        netWorkManager.fetchRecordsByDate(userID: "id", year: viewModel.selectedYear, month: viewModel.selectedMonth) { result in
            switch result {
            case .success(let records):
                fetchedCalendar = records
                
                // 날짜를 Date 형식으로 변환하여 CalendarMetaData에 추가
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for record in fetchedCalendar {
                    // RecordResult에서 날짜를 추출하여 Date로 변환
                    guard let recordDate = dateFormatter.date(from: record.date) else {
                        continue
                    }
                    
                    // 현재 날짜로부터 해당 날짜까지의 일 수를 계산 -> offset 계산
                    let calendar = Calendar.current
                    let daysFromToday = calendar.dateComponents([.day], from: today, to: recordDate).day ?? 0
                    
                    // 각 요소의 deg 값을 확인하고 해당하는 아이콘을 설정
                    let workIcon = self.iconForDeg(record.workDeg ?? 0)
                    let healthIcon = self.iconForDeg(record.healthDeg ?? 0)
                    let familyIcon = self.iconForDeg(record.familyDeg ?? 0)
                    let relationshipIcon = self.iconForDeg(record.relationshipDeg ?? 0)
                    let moneyIcon = self.iconForDeg(record.moneyDeg ?? 0)
                    
                    // Record 객체들을 생성하고 records 배열에 추가
                    var recordsForDate: [Record] = []
                    recordsForDate.append(Record(icon: workIcon, title: "일", subtitle: record.workDoc ?? ""))
                    recordsForDate.append(Record(icon: healthIcon, title: "건강", subtitle: record.healthDoc ?? ""))
                    recordsForDate.append(Record(icon: familyIcon, title: "가족", subtitle: record.familyDoc ?? ""))
                    recordsForDate.append(Record(icon: relationshipIcon, title: "관계", subtitle: record.relationshipDoc ?? ""))
                    recordsForDate.append(Record(icon: moneyIcon, title: "자산", subtitle: record.moneyDoc ?? ""))
                    
                    // CalendarMetaData를 생성
                    let metaData = CalendarMetaData(id: UUID().uuidString,
                                                    records: recordsForDate,
                                                    date: recordDate,
                                                    offset: daysFromToday)
                    processedCalendar.append(metaData)
                }
                
                // 처리된 데이터를 반환
                completion(processedCalendar)
                
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }

    

    func getRecord(for element: String, completion: @escaping (RecordMetaData) -> Void) {
        var fetchedRecords: [RecordResult] = []
        var processedData = RecordMetaData(records: [])

        netWorkManager.fetchRecordsByElement(userID: "id", year: viewModel.selectedYear, month: viewModel.selectedMonth, element: element) { result in
            switch result {
            case .success(let records):
                fetchedRecords = records
                fetchedRecords.sort { $0.date > $1.date }

                let top5Records = Array(fetchedRecords.prefix(5))
                let sortedRecords = top5Records.sorted { $0.date < $1.date }

                processedData = self.processRecords(sortedRecords, for: element)
                print("Fetched records for element:", processedData)
                completion(processedData)

            case .failure(let error):
                print("Error fetching records for element:", error)
                completion(processedData)
            }
        }
    }

    private func processRecords(_ records: [RecordResult], for element: String) -> RecordMetaData {
        var processedData = RecordMetaData(records: [])
        let dateFormatter = DateFormatter()

        for record in records {
            let (degKeyPath, docKeyPath) = getKeyPaths(for: element)
            let degValue = record[keyPath: degKeyPath] ?? 0
            let docValue = record[keyPath: docKeyPath] ?? ""
            let icon = getIcon(for: degValue)
            if let title = formatDateFromString(dateString: record.date) {
                processedData.records.append(Record(id: "id", icon: icon, title: title, subtitle: docValue))
            }
        }

        return processedData
    }

    private func getKeyPaths(for element: String) -> (KeyPath<RecordResult, Int?>, KeyPath<RecordResult, String?>) {
        var degKeyPath: KeyPath<RecordResult, Int?> = \RecordResult.workDeg
        var docKeyPath: KeyPath<RecordResult, String?> = \RecordResult.workDoc

        switch element {
        case "health":
            degKeyPath = \RecordResult.healthDeg
            docKeyPath = \RecordResult.healthDoc
        case "family":
            degKeyPath = \RecordResult.familyDeg
            docKeyPath = \RecordResult.familyDoc
        case "relationship":
            degKeyPath = \RecordResult.relationshipDeg
            docKeyPath = \RecordResult.relationshipDoc
        case "money":
            degKeyPath = \RecordResult.moneyDeg
            docKeyPath = \RecordResult.moneyDoc
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
            return "Xon"
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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy. MM. dd"
            return dateFormatter.string(from: date)
        } else {
            // 날짜 변환 실패 시 nil 반환
            return nil
        }
    }

}
