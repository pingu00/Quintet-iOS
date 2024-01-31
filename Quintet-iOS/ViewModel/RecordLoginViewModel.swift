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
    
    func getCalendar() {
        
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
